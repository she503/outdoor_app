#include "tcp_manager.h"

#include <QDebug>
#include <QTime>
#include <QThread>
#include <QDataStream>
#include <QTimer>
#include "utils.h"
#include <QCoreApplication>


SocketServer::SocketServer(QObject *parent) : QObject(parent)
{
    _socket = new QTcpSocket(this);
    _socket->setReadBufferSize(10 * 1024 * 1024);

    connect(_socket, SIGNAL(readyRead()), this, SLOT(readSocketData()));
    connect(_socket, SIGNAL(disconnected()), this, SLOT(disConnet()));
}

SocketServer::~SocketServer()
{
    _socket->abort();
    _socket->disconnectFromHost();
    _socket->close();
}

void SocketServer::connectToServer(const QString &ip)
{
    _socket->abort();
    _socket->connectToHost(ip, 32432);
    if (!_socket->waitForConnected(1000)) {
        qDebug() << "[SocketServer::connectToHost]: error!!!";
        emit emitConnectRst(false);
    } else {
        QJsonObject object;
        object.insert("message_type", int(MESSAGE_NEW_DEIVCE_CONNECT));
        object.insert("sender", TLSocketType::TERGEO_APP);
        QJsonDocument doc(object);
        this->sendSocketMessage(doc.toJson());
        emit emitConnectRst(true);
    }
}

void SocketServer::disConnet()
{
    QString message = tr("app disconnect to server!");
    _socket->disconnectFromHost();
    _socket->close();
    emit appDisconnected(message);
}

void SocketServer::readSocketData()
{
    if (_socket->bytesAvailable() < 4) {
        return;
    }
    QDataStream in(_socket);
    in.setVersion(QDataStream::Qt_5_9);
    if(_block_size == 0) {
        if(_socket->bytesAvailable() < (int)sizeof(quint64)) return;
        in >> _block_size;
    }

    if(_socket->bytesAvailable() < _block_size) return;

    in >> _buffer;
    this->parseSocketData(_buffer);
    _block_size = 0;
    _buffer = "";
    if (_socket->bytesAvailable() > 0) {
        readSocketData();
    }

}

void SocketServer::parseSocketData(const QByteArray &buffer)
{
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(buffer, &error);
    if (error.error != QJsonParseError::NoError) {
        return;
    }
    QJsonObject obj = doc.object();
    MessageType message_type = MessageType(obj.value("message_type").toInt());
    switch (message_type)
    {
    case  MessageType::MESSAGE_LOGIN_RST:
        emit emitLoginRst(obj);
        break;
    case MessageType::MESSAGE_ADD_ACCOUNT_RST:
        emit emitAddUserRst(obj);
        break;
    case MessageType::MESSAGE_DELETE_ACCOUNT_RST:
        emit emitDeleteUserRst(obj);
        break;
    case MessageType::MESSAGE_UPDATE_ACCOUNT_RST:
        emit emitUpdateUserRst(obj);
        break;
    case MessageType::MESSAGE_ALL_ACCOUNTS_INFO:
        emit emitAllAccountsInfo(obj);
        break;

    case MessageType::MESSAGE_ALL_MAPS_INFO:
        emit emitAllMapsInfo(obj);
        break;
    case MessageType::MESSAGE_SET_INIT_POSE_RST:
        emit emitSetInitPosRST(obj);
        break;
    case MessageType::MESSAGE_CURRENT_MAP_AND_TASKS:
        emit emitMapAndTasks(obj);
        break;
    case MessageType::MESSAGE_CURRENT_WORK_MAP_DATA:
        emit emitCurrentWorkMapData(obj);
        break;
    case MESSAGE_SET_MAP_RST:
        emit emitSetMapNameRst(obj);
        break;
    case MessageType::MESSAGE_SET_TASKS_RST:
        emit emitSetTasksRST(obj);
        break;
    case MessageType::MESSAGE_PAUSE_TASK_RST:
        emit emitPauseTaskRST(obj);
        break;
    case MessageType::MESSAGE_WORK_DONE:
        emit emitWorkDone(obj);
        break;
    case MessageType::MESSAGE_WORK_ERROR:
        emit emitWorkError(obj);
        break;
    case MESSAGE_CURRENT_WORK_FULL_REF_LINE:
        emit emitFullRefLine(obj);
        break;

    case MessageType::MESSAGE_LOCALIZATION_INFO:
        emit emitLocalizationInfo(obj);
        break;
    case MessageType::MESSAGE_TASK_INFO:
        emit emitTaskInfo(obj);
        break;
//    case MessageType::MESSAGE_CHASSIS_INFO:
//        emit emitChassisInfo(obj);
//        break;
    case MessageType::MESSAGE_CLEANING_AGENCY_INFO:
        emit emitCleaningAgencyInfo(obj);
        break;
    case MessageType::MESSAGE_DRIVING_INFO:
        emit emitDrivingInfo(obj);
        break;
    case MessageType::MESSAGE_PERCEPTION_OBSTACLES:
        emit emitObstaclesInfo(obj);
        break;
    case MessageType::MESSAGE_PLANNING_COMMAND_PATH:
        emit emitPlanningPath(obj);
        break;
    case MessageType::MESSAGE_PLANNING_REF_LINE:
        emit emitPlanningRefLine(obj);
        break;
    case MessageType::MESSAGE_BATTERY_SOC:
        emit emitBatteryInfo(obj);
        break;
    case MESSAGE_TRAJECTORY:
        emit emitTrajectoryInfo(obj);
        break;
    case MESSAGE_MONITOR_MESSAGE:
        emit emitMonitorMessage(obj);
        break;
    case MESSAGE_VEHICLE_SIZE:
        this->parseVehicleSize(obj);
        break;
    case MESSAGE_ENABLE_CLEAN_WORK_RST:
        emit emitEnableCleanWorkRst(obj.value("current_status").toBool());
        break;

    case MESSAGE_MAPPING_COMMAND_RST:
        emit emitMappingCommandRst(obj);
        break;
    case MESSAGE_MAPPING_PROGRESS:
        emit emitMappingProgress(obj);
        break;
    case MESSAGE_MAPPING_FINISH:
        emit emitMappingFinish();
        break;
    case MESSAGE_MAPPING_MESSAGE:
        emit emitMappingMessage(obj.value("flag").toBool(), obj.value("message").toString());
        break;
    case MESSAGE_MAPPING_START_SUCCESS:
        emit emitStartMappingSuccess();
        break;
    case MESSAGE_MAPPING_TRANSFER_DATA_RST:
        emit emitTransferDataRst(obj);
        break;
    default:
        break;
    }
}

void SocketServer::parseVehicleSize(const QJsonObject &obj)
{
    _vehicle_info_manager->setVehicleMaxX(obj.value("max_x").toDouble());
    _vehicle_info_manager->setVehicleMaxY(obj.value("max_y").toDouble());
    _vehicle_info_manager->setVehicleMinX(obj.value("min_x").toDouble());
    _vehicle_info_manager->setVehicleMinY(obj.value("min_y").toDouble());


//    _vehicle_info_manager->setVehicleHeight(obj.value("height").toDouble());
//    _vehicle_info_manager->setVehicleWidth(obj.value("width").toDouble());
}

void SocketServer::sendSocketMessage(const QByteArray &message, bool compress)
{
    if (!_socket->isWritable()) {
        return;
    }
    QByteArray temp = message;
    if (compress) {
        temp.replace(" ","").replace("\n","");
    }
    QByteArray block;
    QDataStream out(&block, QIODevice::ReadWrite);
    out.setVersion(QDataStream::Qt_5_9);
    out << (quint64)0;
    out << temp;
    out.device()->seek(0);
    out << (quint64)(block.size() - sizeof(quint64));
    _socket->write(block);
    _socket->flush();
    return;
}

void SocketServer::setVehicleInfoManager(VehicleInfoManager *vehicle_info_manager)
{
    _vehicle_info_manager = vehicle_info_manager;
}

TcpManager::TcpManager(QObject *parent)
    :QObject(parent)
{
    _socket_server = new SocketServer();
    _server_thread = new QThread();
    _socket_server->moveToThread(_server_thread);
    connect(_server_thread, &QThread::finished, _socket_server, &QObject::deleteLater);
    connect(_server_thread, &QThread::finished, _server_thread, &QObject::deleteLater);
    _server_thread->start();

    this->connectFunction();


}

TcpManager::~TcpManager()
{

}

void TcpManager::connectToServer(const QString &ip)
{
    emit emitConnectToServer(ip);
}

void TcpManager::connectFunction()
{
    connect(this, SIGNAL(emitConnectToServer(QString)),
            _socket_server, SLOT(connectToServer(QString)));

    connect(_socket_server, SIGNAL(appDisconnected(QString)),
            this, SIGNAL(appDisconnected(QString)));

    connect(_socket_server, SIGNAL(emitMapAndTasks(QJsonObject)),
            this, SIGNAL(emitMapAndTasks(QJsonObject)));

    connect(_socket_server, SIGNAL(emitSetInitPosRST(QJsonObject)),
            this, SIGNAL(emitSetInitPosRST(QJsonObject)));

    connect(_socket_server, SIGNAL(emitAllMapsInfo(QJsonObject)),
            this, SIGNAL(emitAllMapsInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitAllAccountsInfo(QJsonObject)),
            this, SIGNAL(emitAllAccountsInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitUpdateUserRst(QJsonObject)),
            this, SIGNAL(emitUpdateUserRst(QJsonObject)));

    connect(_socket_server, SIGNAL(emitDeleteUserRst(QJsonObject)),
            this, SIGNAL(emitDeleteUserRst(QJsonObject)));

    connect(_socket_server, SIGNAL(emitAddUserRst(QJsonObject)),
            this, SIGNAL(emitAddUserRst(QJsonObject)));

    connect(_socket_server, SIGNAL(emitLoginRst(QJsonObject)),
            this, SIGNAL(emitLoginRst(QJsonObject)));

    connect(_socket_server, SIGNAL(emitWorkDone(QJsonObject)),
            this, SIGNAL(emitWorkDone(QJsonObject)));

    connect(_socket_server, SIGNAL(emitPauseTaskRST(QJsonObject)),
            this, SIGNAL(emitPauseTaskRST(QJsonObject)));

    connect(_socket_server, SIGNAL(emitSetTasksRST(QJsonObject)),
            this, SIGNAL(emitSetTasksRST(QJsonObject)));

    connect(_socket_server, SIGNAL(emitSetMapNameRst(QJsonObject)),
            this, SIGNAL(emitSetMapNameRst(QJsonObject)));

    connect(_socket_server, SIGNAL(emitFullRefLine(QJsonObject)),
            this, SIGNAL(emitFullRefLine(QJsonObject)));

    connect(_socket_server, SIGNAL(emitCurrentWorkMapData(QJsonObject)),
            this, SIGNAL(emitCurrentWorkMapData(QJsonObject)));

    connect(_socket_server, SIGNAL(emitTransferDataRst(QJsonObject)),
            this, SIGNAL(emitTransferDataRst(QJsonObject)));

    connect(_socket_server, SIGNAL(emitStartMappingSuccess()),
            this, SIGNAL(emitStartMappingSuccess()));

    connect(_socket_server, SIGNAL(emitMappingMessage(bool,QString)),
            this, SIGNAL(emitMappingMessage(bool,QString)));

    connect(_socket_server, SIGNAL(emitMappingFinish()),
            this, SIGNAL(emitMappingFinish()));

    connect(_socket_server, SIGNAL(emitMappingProgress(QJsonObject)),
            this, SIGNAL(emitMappingProgress(QJsonObject)));

    connect(_socket_server, SIGNAL(emitMappingCommandRst(QJsonObject)),
            this, SIGNAL(emitMappingCommandRst(QJsonObject)));

    connect(_socket_server, SIGNAL(emitEnableCleanWorkRst(bool)),
            this, SIGNAL(emitEnableCleanWorkRst(bool)));

    connect(_socket_server, SIGNAL(emitMonitorMessage(QJsonObject)),
            this, SIGNAL(emitMonitorMessage(QJsonObject)));

    connect(_socket_server, SIGNAL(emitTrajectoryInfo(QJsonObject)),
            this, SIGNAL(emitTrajectoryInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitBatteryInfo(QJsonObject)),
            this, SIGNAL(emitBatteryInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitPlanningRefLine(QJsonObject)),
            this, SIGNAL(emitPlanningRefLine(QJsonObject)));

    connect(_socket_server, SIGNAL(emitPlanningPath(QJsonObject)),
            this, SIGNAL(emitPlanningPath(QJsonObject)));

    connect(_socket_server, SIGNAL(emitObstaclesInfo(QJsonObject)),
            this, SIGNAL(emitObstaclesInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitDrivingInfo(QJsonObject)),
            this, SIGNAL(emitDrivingInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitCleaningAgencyInfo(QJsonObject)),
            this, SIGNAL(emitCleaningAgencyInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitTaskInfo(QJsonObject)),
            this, SIGNAL(emitTaskInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitLocalizationInfo(QJsonObject)),
            this, SIGNAL(emitLocalizationInfo(QJsonObject)));

    connect(_socket_server, SIGNAL(emitWorkError(QJsonObject)),
            this, SIGNAL(emitWorkError(QJsonObject)));

    connect(_socket_server, SIGNAL(emitConnectRst(bool)),
            this, SIGNAL(emitConnectRst(bool)));

    connect(this, SIGNAL(setVehicleInfoManager(VehicleInfoManager*)),
            _socket_server, SLOT(setVehicleInfoManager(VehicleInfoManager*)));

    connect(this, SIGNAL(emitSendSocketMessage(QByteArray, bool)),
            _socket_server, SLOT(sendSocketMessage(QByteArray,bool)));
}
