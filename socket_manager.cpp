#include "socket_manager.h"

#include <QDebug>
#include <QTime>
#include <QThread>
#include <QDataStream>
#include <QTimer>

SocketManager::SocketManager(QObject *parent) : QObject(parent)
{
    _socket = new QTcpSocket(this);
    _socket->setReadBufferSize(10 * 1024 * 1024);

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

bool SocketManager::sendClickPointPos(const QString &pos_x, const QString &pos_y)
{
    QJsonObject object;
    object.insert("message_type", "clicked_point");
    object.insert("x", pos_x);
    object.insert("y", pos_y);
    QJsonDocument doc(object);
    return this->sendSocketMessage(doc.toJson());
}

bool SocketManager::sendAllPower(bool flag)
{
    QJsonObject object;
    object.insert("message_type", "power_all");
    object.insert("sender", "mobile_client");
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
            QString message_type = obj.value("message_type").toString();
            if (message_type == "ros_message") {
                this->parseRosInfoData(obj);
            } else if (message_type == "map_data") {
                this->parseMapData(obj);
            } else if (message_type == "localization_info") {
                this->parseLocalization(obj);
            } else if (message_type == "planning_path") {
                this->parsePlanningPath(obj);
            } else if (message_type == "obstacles_info") {
                this->parsePerceptionObstacles(obj);
            } else if (message_type == "reference_line") {
                this->parseReferenceLine(obj);
            } else if (message_type == "pipline_file") {
                emit this->parsePiplineInfoData(obj);
            } else if (message_type == "regions_info") {
                emit this->parseRegionsInfo(obj);
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

void SocketManager::parseRosInfoData(const QJsonObject &obj)
{

}

void SocketManager::parseRegionsInfo(const QJsonObject &obj)
{
    int regions_status = obj.value("status").toInt();
    emit updateRegionsInfo(regions_status);
}

void SocketManager::parsePiplineInfoData(const QJsonObject &obj)
{
    QString file_path = obj.value("file_path").toString();
    QString file_data = obj.value("file_data").toString();
    emit sendpiplineFile(file_path, file_data);
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

void SocketManager::parsePerceptionRoadEdge(const QJsonObject &obj)
{
    QVariantList road_edge = obj.value("road_edge").toVariant().toList();;
    emit updatePerceptionRoadEdge(road_edge);
}

void SocketManager::parseReferenceLine(const QJsonObject &obj)
{
    QVariantList reference_line;
    reference_line.append(obj.value("line").toVariant());
    emit updateReferenceLine(reference_line);
}

void SocketManager::parseMapData(const QJsonObject &obj)
{
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

