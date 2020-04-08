#include "socket_manager.h"

#include <QDebug>
#include <QTime>
#include <QThread>
#include <QDataStream>
#include <QTimer>
#include "utils.h"

SocketManager::SocketManager(QObject *parent) : QObject(parent)
{
    _socket = new QTcpSocket(this);
    _socket->setReadBufferSize(10 * 1024 * 1024);

//    this->connectToHost("127.0.0.1", "32432");
//    this->connectToHost("192.168.0.125", "32432");
    this->connectToHost("192.168.8.143", "32432");

    connect(_socket, SIGNAL(readyRead()), this, SLOT(readSocketData()));
    connect(_socket, SIGNAL(disconnected()), this, SLOT(disConnet()));
}

SocketManager::~SocketManager()
{
    _socket->abort();
    _socket->disconnectFromHost();
    _socket->close();
}

bool SocketManager::connectToHost(const QString &ip, const QString &port)
{
    _socket->abort();
    _socket->connectToHost(ip, port.toInt());
    if (!_socket->waitForConnected(1000)) {
        qDebug() << "[SocketManager::connectToHost]: error!!!";
        return false;
    } else {
        QJsonObject object;
        object.insert("message_type", int(MESSAGE_NEW_DEIVCE_CONNECT));
        QJsonDocument doc(object);
        _is_connected = true;
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

bool SocketManager::sendData(const QByteArray &data)
{
    QByteArray transformate_data = data;
    transformate_data.replace(" ","").replace("\n","");
    //在字段结束加上关键字
    transformate_data += "$";

    qint64 write_result = _socket->write(transformate_data);
    bool is_flush = _socket->flush();
    if (write_result != -1 && is_flush) {
        if (write_result != 0) {
            return true;
        }
    }
    return false;
}

bool SocketManager::judgeIsConnected()
{
    QString message = tr("app cannot to connect server, please check your wifi and IP!");

    if(!_is_connected) {
        emit emitFaildToLogin(message);
    }
    return _is_connected;
}

void SocketManager::readSocketData(/*const QByteArray& buffer*/)
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
        _buffer = buffer_list.at(i);
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(_buffer, &error);
        if (error.error == QJsonParseError::NoError) {
            QJsonObject obj = doc.object();

            MessageType message_type = MessageType(obj.value("message_type").toInt());
            switch (message_type) {
            case MessageType::MESSAGE_ALL_MAPS_INFO:
                emit mapsInfo(obj);
                break;
            case MessageType::MESSAGE_SET_INIT_POSE_RST:
                emit setInitPosRST(obj);
                break;
            case MessageType::MESSAGE_CURRENT_MAP_AND_TASKS:
                emit sendMapAndTasks(obj); //yi ge di tu he gai di tu de suo you can kao xian
                break;
            case MessageType::MESSAGE_TASKS_INFO:
                emit tasksData(obj);
                break;
            case MessageType::MESSAGE_CURRENT_MAP_AND_TASK:
                emit sendMapAndTask(obj); // yi ge di tu he dui ying de yi jing xuan ze hao de can kao xian
                break;
            case MESSAGE_SET_MAP_RST:
                emit parseMapName(obj);
                break;

            case  MessageType::MESSAGE_LOGIN_RST:
                emit checkoutLogin(obj);
                break;
            case MessageType::MESSAGE_SET_TASKS_RST:
                emit setTasksRST(obj);
                break;
            case MessageType::MESSAGE_PAUSE_TASK_RST:
                emit pauseTaskRST(obj.value("current_status").toBool(),obj.value("status").toInt());
                break;
            case MessageType::MESSAGE_STOP_TASK_RST:
                emit pauseStopTaskRST(obj.value("status").toInt());
                break;


            case MessageType::MESSAGE_ADD_ACCOUNT_RST:
                emit addUser(obj);
                break;
            case MessageType::MESSAGE_DELETE_ACCOUNT_RST:
                emit deleteUser(obj);
                break;
            case MessageType::MESSAGE_UPDATE_ACCOUNT_RST:
                emit updateUser(obj);
                break;
            case MessageType::MESSAGE_ALL_ACCOUNTS_INFO:
                emit allUser(obj);
                break;


            case MessageType::MESSAGE_LOCALIZATION_INFO:
                emit localizationInfo(obj);
                break;
            case MessageType::MESSAGE_TASK_INFO:
                emit taskProcessInfo(obj);
                break;
            case MessageType::MESSAGE_CHASSIS_INFO:
                emit chassisInfo(obj);
                break;
            case MessageType::MESSAGE_PERCEPTION_OBSTACLES:
                emit obstaclesInfo(obj);
                break;
            case MessageType::MESSAGE_PLANNING_COMMAND_PATH:
                emit planningInfo(obj);
                break;
            case MessageType::MESSAGE_PLANNING_REF_LINE:
                emit planningRefInfo(obj);
                break;
            case MessageType::MESSAGE_BATTERY_SOC:
                emit batteryInfo(obj);
                break;

            default:
                qDebug() << "======>" <<obj;
                break;
            }
        } else {
            qDebug() << "[SocketManager::readSocketData]: json error  " << error.errorString();

        }
    }
    _buffer = buffer_list.at(complete_buffer_num);
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
