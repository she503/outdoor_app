#include "socket_manager.h"

#include <QDebug>
#include <QTime>
#include <QThread>
#include <QDataStream>

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

bool SocketManager::connectToHost(const QString &ip, const QString &port)
{
    _socket->abort();
    _socket->connectToHost(ip, port.toInt());
    if (!_socket->waitForConnected(1000)) {
        qDebug() << "[SocketManager::connectToHost]: error!!!";
        return false;
    } else {
        QJsonObject object;
        object.insert("message_type", "mobile_client_connected");
        object.insert("sender", "mobile_client");
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

bool SocketManager::sendAllPower(bool flag)
{
    QJsonObject object;
    object.insert("message_type", "power_all");
    object.insert("sender", "mobile_client");
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::sendModulePower(bool flag, const QString &module)
{
    QJsonObject object;
    object.insert("message_type", "power_module");
    object.insert("sender", "mobile_client");
    object.insert("module_name", module);
    object.insert("flag", flag);
    QJsonDocument doc(object);;
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::sendEmergency(bool flag)
{
    QJsonObject object;
    if (flag) {
        object.insert("message_type", "emergency_stop");
    } else {
        object.insert("message_type", "release_emergency");
    }
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::sendConfInfoData(const QString &file_path, const QString &conf_data, const int &write_flag)
{
    QJsonObject object;
    object.insert("message_type", "edit_conf_file");
    object.insert("sender", "mobile_client");
    object.insert("file_path", "/" + file_path);
    object.insert("conf_data", conf_data);
    object.insert("write_flag", write_flag);
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::sendLineSpeedAndAngularSpeed(const float &line_speed, const float &angular_speed)
{
    QJsonObject object;
    object.insert("message_type", "line_angular_speed_info");
    object.insert("line_speed", line_speed);
    object.insert("angular_speed", angular_speed);
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::sendClickPointPos(const QString &pos_x, const QString &pos_y)
{
    QJsonObject object;
    object.insert("message_type", "clicked_point");
    object.insert("x", pos_x);
    object.insert("y", pos_y);
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::getRostopic()
{
    QJsonObject object;
    object.insert("message_type", "get_all_rostopic");
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::startOrStopRecord(const QString &status, const QString& data)
{
    QJsonObject object;
    object.insert("message_type", "record_data");
    object.insert("status", status);
    object.insert("data", data);
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::getConfData(const QString &file_path)
{
    QJsonObject object;
    object.insert("message_type", "get_conf_data");
    object.insert("file_path", file_path);
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

//bool SocketManager::sendHandOperateInfo(const bool &is_hand)
//{
//    QJsonObject object;
//    object.insert("message_type", "operate_method");
//    object.insert("is_hand_operate", is_hand);
//    QJsonDocument doc(object);
//    return this->sendSocketMessage(doc.toJson());
//}

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
            QString message_type = obj.value("message_type").toString();
            if (message_type == "modules_status") {
                this->parseModulesStatus(obj);
            } else if (message_type == "conf_edit_rst") {
                this->parseConfInfoData(obj);
            } else if (message_type == "ros_message") {
                this->parseRosInfoData(obj);
            } else if (message_type == "map_data") {
                this->parseMapData(obj);
            } else if (message_type == "localization_info") {
                this->parseLocalization(obj);
            } else if (message_type == "planning_path") {
                this->parsePlanningPath(obj);
            } else if (message_type == "obstacles_info") {
                this->parsePerceptionObstacles(obj);
            } else if (message_type == "brain_status") {
                this->parseBrainStatus(obj);
            } else if (message_type == "reference_line") {
                this->parseReferenceLine(obj);
            } else if (message_type == "all_rostopic") {
                emit this->sendRostopic(obj.value("topic_list").toVariant());
            } else if (message_type == "record_status") {
                emit this->sendRecordStatus(obj.value("record_status").toString());
            } else if (message_type == "pipline_file") {
                emit this->parsePiplineInfoData(obj);
            }
            else {
                qDebug() << "other message type!!!";
            }
        } else {
            qDebug() << "[SocketManager::readSocketData]: json error  " << error.errorString();

        }
    }
    _buffer = buffer_list.at(complete_buffer_num);
}

void SocketManager::parseModulesStatus(const QJsonObject &obj)
{
    QJsonObject modules_status = obj.value("modules_status").toObject();
    QJsonObject::const_iterator begin = modules_status.constBegin();
    QJsonObject::const_iterator end = modules_status.constEnd();
    int active_num = 0;


    for (QJsonObject::const_iterator iter = begin; iter != end; ++iter) {
        bool flag = iter.value().toObject().value("is_running").toBool();
        float cpu_rate = iter.value().toObject().value("cpu_rate").toDouble();
        float mem_rate = iter.value().toObject().value("mem_rate").toDouble();
        if (iter.key() == "Vehicle") {
            emit sendVehicleStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
        if (iter.key() == "Localization") {
            emit sendLocalizationStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
        if (iter.key() == "Prediction") {
            emit sendMapStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
        if (iter.key() == "Monitor") {
            emit sendMonitorStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
        if (iter.key() == "Perception") {
            emit sendPerceptionStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
        if (iter.key() == "Planning") {
            emit sendPlanningStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
        if (iter.key() == "Control") {
            emit sendControlStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
        if (iter.key() == "Guardian") {
            emit sendGuardianStatus(flag, cpu_rate, mem_rate);
            if (flag) {
                ++active_num;
            }
        }
//        if (iter.key() == "Lidar") {
//            emit sendLidarStatus(flag, cpu_rate, mem_rate);
//            if (flag) {
//                ++active_num;
//            }
//        }
    }
    emit sendActiveNum(active_num);
}

void SocketManager::parseConfInfoData(const QJsonObject &obj)
{
    QString file_path = obj.value("file_path").toString();
    int write_flag = obj.value("write_flag").toInt();
    emit sendConfWriteStatus(file_path, write_flag);
}

void SocketManager::parseRosInfoData(const QJsonObject &obj)
{
    if (obj.contains("chassis_info")) {
        this->parseChassisInfo(obj.value("chassis_info").toObject());
    }
    if (obj.contains("battery_info")) {
        this->parseBatteryInfo(obj.value("battery_info").toObject());
    }
    if (obj.contains("gps_info")) {
        this->parseGpsInfo(obj.value("gps_info").toObject());
    }
    if (obj.contains("guardian_info")) {
        this->parseGuardianInfo(obj.value("guardian_info").toObject());
    }
    if (obj.contains("control_info")) {
        this->parseControlInfo(obj.value("control_info").toObject());
    }
}

void SocketManager::parsePiplineInfoData(const QJsonObject &obj)
{
//    qDebug() << obj;
    QString file_path = obj.value("file_path").toString();
    QString file_data = obj.value("file_data").toString();
    emit sendpiplineFile(file_path, file_data);
}

void SocketManager::parseChassisInfo(const QJsonObject &obj)
{
    QString time = obj.value("time").toString();
    QString speed_mps = obj.value("speed_mps").toString();
    QString omega_radps = obj.value("omega_radps").toString();
    QString brake = obj.value("brake").toString();
    QString drive_button = obj.value("drive_button").toString();
    QString drive_mode = obj.value("drive_mode").toString();
    emit updateChassisInfo(time, speed_mps.toFloat(), omega_radps.toFloat(), brake, drive_button, drive_mode);
}

void SocketManager::parseBatteryInfo(const QJsonObject &obj)
{
    QString time = obj.value("time").toString();
    float soc = obj.value("SOC").toDouble();
    float temperature = obj.value("temperature").toDouble();
    emit updateBatteryInfo(time, soc,temperature);

}

void SocketManager::parseGpsInfo(const QJsonObject &obj)
{
    QString time = obj.value("time").toString();
    QString B = obj.value("B").toString();
    QString L = obj.value("L").toString();
    QString heading = obj.value("heading").toString();
    QString state = obj.value("state").toString();
    emit updateGpsInfo(time, B, L, heading, state);
}

void SocketManager::parseGuardianInfo(const QJsonObject &obj)
{

    QString time = obj.value("time").toString();
    QString brake_cmd = obj.value("brake_cmd").toString();
    QString omega_radps = obj.value("omega_radps").toString();
    QString speed_mps = obj.value("speed_mps").toString();
    QString lighting = obj.value("lighting").toString();
    QString trumpet = obj.value("trumpet").toString();
    QString left_steer_light = obj.value("left_steer_light").toString();
    QString right_steer_light = obj.value("right_steer_light").toString();
    QString indicator_lighting = obj.value("indicator_lighting").toString();
    QString sweeping = obj.value("sweeping").toString();
    QString water_pump = obj.value("water_pump").toString();
    QString lifting_motor = obj.value("lifting_motor").toString();

    emit updateGuardianInfo(time, brake_cmd, omega_radps, speed_mps, lighting, trumpet, left_steer_light, right_steer_light,
                            indicator_lighting, sweeping, water_pump, lifting_motor);

}

void SocketManager::parseLocalization(const QJsonObject &obj)
{
    QString time = obj.value("time").toString();
    QString X = obj.value("X").toString();
    QString Y = obj.value("Y").toString();
    QString heading = obj.value("heading").toString();
    QString state = obj.value("state").toString();
    emit updateLocalization(time, X, Y, heading, state);
}

void SocketManager::parsePlanningPath(const QJsonObject &obj)
{
    QVariantList path = obj.value("path").toVariant().toList();
    emit updatePlanningPath(path);
}

void SocketManager::parsePerceptionObstacles(const QJsonObject &obj)
{
    QVariantList obstacles = obj.value("obstacles").toVariant().toList();
    bool is_polygon = obj.value("is_polygon").toBool();
    emit updatePerceptionObstacles(obstacles, is_polygon);
}

void SocketManager::parseBrainStatus(const QJsonObject &obj)
{
    int temperature = obj.value("temperature").toInt();
    emit updateBrainStatus(temperature);
}

void SocketManager::parsePerceptionRoadEdge(const QJsonObject &obj)
{
    QVariantList road_edge = obj.value("road_edge").toVariant().toList();;
    emit updatePerceptionRoadEdge(road_edge);
}

//void SocketManager::parseNotification(const QJsonObject &obj)
//{
//    QVariantList obstacles = obj.value("obstacles").toVariant().toList();
//    emit updatePerceptionObstacles(obstacles);
//}

void SocketManager::parseReferenceLine(const QJsonObject &obj)
{
    QVariantList reference_line;
    reference_line.append(obj.value("line").toVariant());
    emit updateReferenceLine(reference_line);
}

void SocketManager::parseControlInfo(const QJsonObject &obj)
{
    QString time = obj.value("time").toString();
    QString success = obj.value("success").toString();
    QString omega_radps = obj.value("omega_radps").toString();
    QString speed_mps = obj.value("speed_mps").toString();

    emit updateControlInfo(time, success, omega_radps, speed_mps);
}

void SocketManager::parseMapData(const QJsonObject &obj)
{
//    qDebug() << obj;
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

