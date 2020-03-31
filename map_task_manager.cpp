#include "map_task_manager.h"

MapTaskManager::MapTaskManager(QObject *parent) : QObject(parent)
{

}

void MapTaskManager::setSocket(SocketManager *socket)
{
    _socket = socket;
    connect(_socket, SIGNAL(mapsInfo(QJsonObject)), this, SLOT(parseRegionsInfo(QJsonObject)));
    connect(_socket, SIGNAL(tasksData(QJsonObject)), this, SLOT(parsseMapTasksData(QJsonObject)));
    connect(_socket, SIGNAL(localizationInitRST(QJsonObject)), this, SLOT(localizationInitCB(QJsonObject)));
    connect(_socket, SIGNAL(setTasksRST(QJsonObject)), this, SLOT(setTaskCB(QJsonObject)));
}

bool MapTaskManager::sendClickPointPos(const QString &pos_x, const QString &pos_y)
{
    QJsonObject object;
    object.insert("message_type", int(MESSAGE_SET_INIT_LOCALIZATION));
    object.insert("x", pos_x);
    object.insert("y", pos_y);
    QJsonDocument doc(object);
    _socket->sendSocketMessage(doc.toJson());
}


void MapTaskManager::getTasksData(const QStringList &task_name)
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

void MapTaskManager::getFeature(const QString &map_name)
{
    if (_feature_obj.empty()) {
        return;
    }
    QJsonObject feature_obj = _feature_obj.value(map_name).toObject();
    QJsonObject begin_obj = feature_obj.value("begin_point").toObject();
    QJsonObject charge_obj = feature_obj.value("charge_point").toObject();
    emit updateMapFeature(begin_obj, charge_obj);
}

void MapTaskManager::getMapTask(const QString &map_name)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_SET_MAP));
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    _socket->sendSocketMessage(doc.toJson());
}

void MapTaskManager::getMapsName()
{
    if (_map_name_list.size() != 0 ) {
        emit updateMapsName(_map_name_list);
    } else {

    }
}

void MapTaskManager::sentMapTasksName(const QStringList &task_list)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_SET_TASKS));
    obj.insert("tasks_name",QJsonArray::fromStringList(task_list));
    QJsonDocument doc(obj);
    _socket->sendSocketMessage(doc.toJson());
}



void MapTaskManager::parseTasksName(const QJsonObject &tasks_obj)
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

void MapTaskManager::localizationInitCB(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit localizationInitInfo(status, message);
}

void MapTaskManager::setTaskCB(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit setTaskInfo(status, message);
    if (status == 1) {
        QJsonObject temp_obj = obj.value("ref_line").toObject();
        QVariantList pts = temp_obj.value("pts").toArray().toVariantList();
        emit updateRefLine(pts);
    }
}
void MapTaskManager::parseRegionsInfo(const QJsonObject &obj)
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

void MapTaskManager::parsseMapTasksData(const QJsonObject &obj)
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




void MapTaskManager::parseMapData(const QString &map_name)
{
    if (_maps.size() == 0) {
        return;
    }
    QJsonObject obj = _maps.value(map_name);

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

QVariantList MapTaskManager::parseSignals(const QJsonObject &obj)
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

QVariantList MapTaskManager::parseTrees(const QJsonObject &obj)
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

QVariantList MapTaskManager::parseStopSigns(const QJsonObject &obj)
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

QVariantList MapTaskManager::parseSpeedBumps(const QJsonObject &obj)
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

QVariantList MapTaskManager::parseRoadEdges(const QJsonObject &obj)
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

QVariantList MapTaskManager::parseLaneLines(const QJsonObject &obj)
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

QList<QVariantList> MapTaskManager::parseClearAreas(const QJsonObject &obj)
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

QList<QVariantList> MapTaskManager::parseCrosswalks(const QJsonObject &obj)
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

QList<QVariantList> MapTaskManager::parseJunctions(const QJsonObject &obj)
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

QList<QVariantList> MapTaskManager::parseParkingSpaces(const QJsonObject &obj)
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

QList<QVariantList> MapTaskManager::parseRoads(const QJsonObject &obj)
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


