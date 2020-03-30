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

    this->connectToHost("127.0.0.1", "32432");
//    this->connectToHost("192.168.8.165", "32432");

    connect(_socket, SIGNAL(readyRead()), this, SLOT(readSocketData()));
    connect(_socket, SIGNAL(disconnected()), this, SLOT(disConnet()));
    testfunction();
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
        this->sendSocketMessage(doc.toJson());
        return true;
    }
}

bool SocketManager::disConnet()
{
    _socket->disconnectFromHost();
    _socket->close();
    emit appDisconnected();
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

bool SocketManager::sendClickPointPos(const QString &pos_x, const QString &pos_y)
{
    QJsonObject object;
    object.insert("message_type", MESSAGE_INIT_LOCALIZATION);
    object.insert("x", pos_x);
    object.insert("y", pos_y);
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
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
            case MessageType::MESSAGE_MAPS_INFO:
                this->parseRegionsInfo(obj);
                break;
            case MessageType::MESSAGE_TASKS_INFO:
                this->parsseMapTasksData(obj);
                break;
            case  MessageType::MESSAGE_LOGIN_RST:
                emit checkoutLogin(obj);
//                this->checkOutLogin(obj);
                break;
            case MessageType::MESSAGE_ADD_ACCOUNT_RST:
                this->parserAddStatus(obj);
                break;
            case MessageType::MESSAGE_DELETE_ACCOUNT_RST:
                this->parseDeleteStatus(obj);
                break;
            case MessageType::MESSAGE_UPDATE_ACCOUNT_RST:
                this->parseUpdateStatus(obj);
                break;
            case MessageType::MESSAGE_ALL_ACCOUNTS_INFO:
                this->parseAllAccountsInfo(obj);
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

void SocketManager::getAllAccountInfo(const QJsonObject &obj)
{
    QJsonObject account_username_level;
    QJsonObject::const_iterator it = obj.begin();
    while (it != obj.end()) {
        QString username = it.key();
        QJsonObject temp = it.value().toObject();
        int permission_level = temp.value("permission_level").toInt();
        account_username_level.insert(username, permission_level);
        ++it;
    }
    _all_accounts_obj = account_username_level;
    emit emitAllAccountInfo(account_username_level);
}

void SocketManager::testfunction()
{
    QTimer *time = new QTimer();

    time->setInterval(100);
    connect(time,&QTimer::timeout,[=](){
        soc = (soc + 1) % 100;
        speed = (speed + 1) % 30;
        water_volume = (water_volume + 1) % 100;
        emit updateBatteryInfo(QString::number(soc));
        emit updateVehicleSpeed(QString::number(speed));
        emit updateWaterVolume(QString::number(water_volume));
    });
    time->start();
}


void SocketManager::getTasksData(const QStringList &task_name)
{
    if(_tasks.size() <= 0) {
        return;
    }

    QVariantList points;
    QVariantList regions;
    QVariantList lines;

    for (int i = 0; i < task_name.size(); ++i) {

        qint8 task_type = _tasks.value(task_name.at(i)).first;
        QVariantList task_data = _tasks.value(task_name.at(i)).second;

        if (task_type == 1) {
            lines.push_back(task_data);
        } else if (task_type == 2) {
            points.push_back(task_data);
        } else if (task_type == 3) {
            regions.push_back(task_data);
        }
    }

    emit updateTaskData(points, regions, lines);

}

void SocketManager::getMapTask(const QString &map_name)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_SET_MAP));
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    this->sendSocketMessage(doc.toJson());
}

void SocketManager::parseRegionsInfo(const QJsonObject &obj)
{
    qint8 status = obj.value("status").toInt();
    if (status == 0) {
        QString error_message = obj.value("message").toString();
        qDebug() << "[SocketManager::parseRegionsInfo]: " << error_message;
        emit getMapInfoError(error_message);
        return;
    }
    _map_name_list.clear();
    _maps.clear();
    QJsonObject map_obj = obj.value("maps").toObject();

    QJsonObject::Iterator it;

    for(it = map_obj.begin(); it != map_obj.end(); ++it) {
        QString map_name = it.key();
        QJsonObject map_temp_obj = it.value().toObject();
        QJsonObject area_obj = map_temp_obj.value("area").toObject();
        _map_name_list.push_back(map_name);
        _maps.insert(map_name, area_obj);

        QJsonObject features_obj = map_temp_obj.value("features").toObject();

        QJsonObject feature_temp_obj;
        QJsonObject begin_point_obj = features_obj.value("begin_point").toObject();
        QJsonObject charge_point_obj = features_obj.value("charge_point").toObject();
        feature_temp_obj.insert("begin_point", begin_point_obj);
        feature_temp_obj.insert("charge_point", charge_point_obj);
        _feature_obj.insert(map_name, feature_temp_obj);
       }


}



void SocketManager::parsseMapTasksData(const QJsonObject &obj)
{
    qint8 status = obj.value("status").toInt();
    QString message  = obj.value("message").toString();

    if (status == 0) {
        qDebug() << "[SocketManager::parsseMapTasksData]: " << message;
        return;
    } else {
        QJsonObject task_data_obj = obj.value("tasks").toObject();
        this->parseTasksName(task_data_obj);
    }

}

void SocketManager::parseTasksName(const QJsonObject& tasks_obj)
{
    _tasks.clear();
    _task_name.clear();
    if (_maps.size() <= 0) {
        return;
    }

    QJsonObject::const_iterator it;//Iterator it;

    for(it = tasks_obj.begin(); it != tasks_obj.end(); ++it) {
        QJsonObject temp_obj = it.value().toObject();
        QString task_name = temp_obj.value("name").toString();

        QVariantList points = temp_obj.value("points").toArray().toVariantList();
        qint8 task_type = temp_obj.value("task_type").toInt();

        QPair<qint8, QVariantList> type_point(task_type, points);
        _tasks.insert(task_name, type_point);
        _task_name.push_back(task_name);
    }
    emit updateTasksName(_task_name);
}



void SocketManager::getMapsName()
{
    if (_map_name_list.size() != 0 ) {
        emit updateMapsName(_map_name_list);
    } else {

    }
}

void SocketManager::sentMapTasksName(const QStringList &task_list)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_SET_TASKS));
    obj.insert("tasks_name",QJsonArray::fromStringList(task_list));
    QJsonDocument doc(obj);
    this->sendSocketMessage(doc.toJson());

}

void SocketManager::getFeature(const QString &map_name)
{
    if (_feature_obj.empty()) {
        return;
    }
    QJsonObject feature_obj = _feature_obj.value(map_name).toObject();
    QJsonObject begin_obj = feature_obj.value("begin_point").toObject();
    QJsonObject charge_obj = feature_obj.value("charge_point").toObject();
    emit updateMapFeature(begin_obj, charge_obj);
}

void SocketManager::accountLogin(const QString &username, const QString &password)
{
    QJsonObject obj;
    obj.insert("message_type", int(MessageType::MESSAGE_LOGIN));
    obj.insert("name", username);
    obj.insert("password", password);
    QJsonDocument doc(obj);
    this->sendSocketMessage(doc.toJson());
}

void SocketManager::accountAdd(const QString &username, const QString &password, const int &level)
{
    QJsonObject obj;
    obj.insert("message_type", int(MessageType::MESSAGE_ADD_ACCOUNT));
    obj.insert("name", username);
    obj.insert("password", password);
    obj.insert("permission_level", level);
    QJsonDocument doc(obj);
    this->sendSocketMessage(doc.toJson());
}

void SocketManager::getAllAccounts()
{
    if (!_all_accounts_obj.empty()) {
        emit emitAllAccountInfo(_all_accounts_obj);
    }
}

void SocketManager::accountDelete(const QString &username)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_DELETE_ACCOUNT));
    obj.insert("name", username);
    QJsonDocument doc(obj);
    this->sendSocketMessage(doc.toJson());
}

void SocketManager::accountUpdate(const QString &username, const QString &password, const int &level)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_UPDATE_ACCOUNT));
    obj.insert("name", username);
    obj.insert("password", password);
    obj.insert("permission_level", level);
    QJsonDocument doc(obj);
    this->sendSocketMessage(doc.toJson());
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

void SocketManager::checkOutLogin(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitCheckOutLogin(status, message);
}

void SocketManager::parserAddStatus(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitAddAccountCB(status, message);
}

void SocketManager::parseDeleteStatus(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitDeleteAccountCB(status, message);
}

void SocketManager::parseUpdateStatus(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitUpdateAccountCB(status, message);
}

void SocketManager::parseAllAccountsInfo(const QJsonObject &obj)
{
    QJsonObject accounts_info = obj.value("accounts_info").toObject();
    this->getAllAccountInfo(accounts_info);
}

void SocketManager::parseMapData(const QString& name)
{
    if (_maps.size() == 0) {
        return;
    }
    QJsonObject obj = _maps.value(name);

    QVariantList var_trees;
    var_trees = this->parseTrees(obj);

    QVariantList var_signals;
    var_signals = this->parseSignals(obj);

    QVariantList var_stop_signs;
    var_stop_signs = this->parseStopSigns(obj);

    QVariantList var_speed_bumps;
    var_speed_bumps = this->parseSpeedBumps(obj);

    QVariantList var_road_edges;
    var_road_edges = this->parseRoadEdges(obj);

    QVariantList var_lane_lines;
    var_lane_lines = this->parseLaneLines(obj);

    QList<QVariantList> var_clear_areas;
    var_clear_areas = this->parseClearAreas(obj);
    QVariantList var_clear_areas_include;

    if (var_clear_areas.size() != 0) {
        var_clear_areas_include = var_clear_areas.at(0);
    }


    QList<QVariantList> var_crosswalks;
    var_crosswalks = this->parseCrosswalks(obj);
    QVariantList var_crosswalks_include;
    if (var_crosswalks.size() != 0) {
        var_crosswalks_include = var_crosswalks.at(0);
    }


    QList<QVariantList> var_junctions;
    var_junctions = this->parseJunctions(obj);
    QVariantList var_junctions_include;
    if (var_junctions.size() != 0) {
        var_junctions_include = var_junctions.at(0);
    }

    QList<QVariantList> var_parking_spaces;
    var_parking_spaces = this->parseParkingSpaces(obj);
    QVariantList var_parking_spaces_include;
    if (var_parking_spaces.size() != 0) {
        var_parking_spaces_include = var_parking_spaces.at(0);
    }

    QList<QVariantList> var_roads;
    var_roads = this->parseRoads(obj);
    QVariantList var_roads_include = var_roads.at(0);
    QVariantList var_roads_exclude;
    if (var_roads.size() == 2) {
        var_roads_exclude = var_roads.at(1);
    }

    emit updateMapData(var_trees, var_signals,
                       var_stop_signs, var_speed_bumps,
                       var_road_edges, var_lane_lines,
                       var_clear_areas_include, var_crosswalks_include,
                       var_junctions_include, var_parking_spaces_include,
                       var_roads_include, var_roads_exclude);
}

//void SocketManager::parseLocalization(const QJsonObject &obj)
//{
//    QString time = obj.value("time").toString();
//    QString X = obj.value("X").toString();
//    QString Y = obj.value("Y").toString();
//    QString heading = obj.value("heading").toString();
//    QString state = obj.value("state").toString();
//    emit updateLocalization(time, X, Y, heading, state);
//}

//void SocketManager::parsePlanningPath(const QJsonObject &obj)
//{
//    QVariantList path = obj.value("path").toVariant().toList();
//    emit updatePlanningPath(path);
//}

//void SocketManager::parsePerceptionObstacles(const QJsonObject &obj)
//{
//    QVariantList obstacles = obj.value("obstacles").toVariant().toList();
//    bool is_polygon = obj.value("is_polygon").toBool();
//    emit updatePerceptionObstacles(obstacles, is_polygon);
//}

//void SocketManager::parsePerceptionRoadEdge(const QJsonObject &obj)
//{
//    QVariantList road_edge = obj.value("road_edge").toVariant().toList();;
//    emit updatePerceptionRoadEdge(road_edge);
//}

//void SocketManager::parseReferenceLine(const QJsonObject &obj)
//{
//    QVariantList reference_line;
//    reference_line.append(obj.value("line").toVariant());
//    emit updateReferenceLine(reference_line);
//}

QVariantList SocketManager::parseSignals(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("road_signals")) {
        QJsonObject temp_obj = obj.value("road_signals").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList SocketManager::parseTrees(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("trees")) {
        QJsonObject temp_obj = obj.value("trees").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList SocketManager::parseStopSigns(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("stop_signs")) {
        QJsonObject temp_obj = obj.value("stop_signs").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList SocketManager::parseSpeedBumps(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("speed_bumps")) {
        QJsonObject temp_obj = obj.value("speed_bumps").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList SocketManager::parseRoadEdges(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("road_edges")) {
        QJsonObject temp_obj = obj.value("road_edges").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QJsonObject pos_obj = temp_obj.value(QString::number(i)).toObject();
                QJsonArray temp_arr;
                temp_arr.append(pos_obj.value("pos"));
                temp_arr.append(pos_obj.value("type"));
                QVariant pos = temp_arr;
                list.append(pos);
        }
    }
    return list;
}

QVariantList SocketManager::parseLaneLines(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("lane_lines")) {
        QJsonObject temp_obj = obj.value("lane_lines").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QJsonObject pos_obj = temp_obj.value(QString::number(i)).toObject();
                QJsonArray temp_arr;
                temp_arr.append(pos_obj.value("pos"));
                temp_arr.append(pos_obj.value("type"));
                QVariant pos = temp_arr;
                list.append(pos);
        }
    }
    return list;
}

QList<QVariantList> SocketManager::parseClearAreas(const QJsonObject &obj)
{
    QList<QVariantList> list;
    if (obj.contains("clear_areas")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("clear_areas").toObject();

        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }


    }
    return list;
}

QList<QVariantList> SocketManager::parseCrosswalks(const QJsonObject &obj)
{
    QList<QVariantList> list;
    if (obj.contains("crosswalks")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("crosswalks").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}

QList<QVariantList> SocketManager::parseJunctions(const QJsonObject &obj)
{
    QList<QVariantList> list;
    if (obj.contains("junctions")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("junctions").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}

QList<QVariantList> SocketManager::parseParkingSpaces(const QJsonObject &obj)
{
    QList<QVariantList> list;
    if (obj.contains("parking_spaces")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("parking_spaces").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}

QList<QVariantList> SocketManager::parseRoads(const QJsonObject &obj)
{
    QList<QVariantList> list;
    if (obj.contains("roads")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("roads").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        }
        if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}

