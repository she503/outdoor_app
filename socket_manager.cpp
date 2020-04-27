#include "socket_manager.h"

#include <QDebug>
#include <QTime>
#include <QThread>
#include <QDataStream>
#include <QTimer>
#include "utils.h"
#include <QCoreApplication>


SocketManager::SocketManager(QObject *parent) : QObject(parent)
{
    _socket = new QTcpSocket(this);
    _socket->setReadBufferSize(10 * 1024 * 1024);

    connect(_socket, SIGNAL(readyRead()), this, SLOT(readSocketData()));
    connect(_socket, SIGNAL(disconnected()), this, SLOT(disConnet()));
}

SocketManager::~SocketManager()
{
    _socket->abort();
    _socket->disconnectFromHost();
    _socket->close();
}

bool SocketManager::connectToServer()
{
    return this->connectToHost("127.0.0.1", "32432");
//    return this->connectToHost("192.168.8.127", "32432");
//    return this->connectToHost("192.168.1.125", "32432");
//    return this->connectToHost("192.168.1.102", "32432");
}

bool SocketManager::connectToHost(const QString &ip, const QString &port)
{
    _socket->abort();
    _socket->connectToHost(ip, port.toInt());
    if (!_socket->waitForConnected(1000)) {
        qDebug() << "[SocketManager::connectToHost]: error!!!";
        emit emitConnectToServerError();
        return false;
    } else {
        QJsonObject object;
        object.insert("message_type", int(MESSAGE_NEW_DEIVCE_CONNECT));
        object.insert("sender", TLSocketType::TERGEO_APP);
        QJsonDocument doc(object);
        this->sendSocketMessage(doc.toJson());
        return true;
    }
}

bool SocketManager::disConnet()
{
    QString message = tr("app disconnect to server!");
    _socket->disconnectFromHost();
    _socket->close();
    emit appDisconnected(message);
    return true;
}

void SocketManager::readSocketData()
{
    if (_socket->bytesAvailable() < 4) {
        return;
    }
    _buffer += _socket->readAll();
    QByteArrayList buffer_list = _buffer.split('$');
    int complete_buffer_num = 0;
    if (buffer_list.size() == 1) {
        return;
    } else {
        complete_buffer_num = buffer_list.size() - 1;
    }

    for (int i = 0; i < complete_buffer_num; ++i) {
        this->parseSocketData(buffer_list.at(i));
    }
    _buffer = buffer_list.at(complete_buffer_num);
}

void SocketManager::parseSocketData(const QByteArray &buffer)
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
    case MessageType::MESSAGE_CHASSIS_INFO:
        emit emitChassisInfo(obj);
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
    default:
        break;
    }
}

void SocketManager::parseVehicleSize(const QJsonObject &obj)
{
    _vehicle_info_manager->setVehicleHeight(obj.value("height").toDouble());
    _vehicle_info_manager->setVehicleWidth(obj.value("width").toDouble());
}

bool SocketManager::sendSocketMessage(const QByteArray &message)
{
    if (!_socket->isWritable()) {
        return false;
    }
    QByteArray temp_message = message;
    temp_message += '$';
    qint64 write_result = _socket->write(temp_message);
    bool is_flush = _socket->flush();
    if (write_result != -1 && is_flush) {
        if (write_result != 0) {
            return true;
        }
    }
    return false;
}

void SocketManager::setVehicleInfoManager(VehicleInfoManager *vehicle_info_manager)
{
    _vehicle_info_manager = vehicle_info_manager;
}
