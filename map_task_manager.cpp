#include "map_task_manager.h"
#include "qjson_transformer.h"

MapTaskManager::MapTaskManager(QObject *parent) : QObject(parent)
{
    _work_status = WORK_STATUS_NONE_WORK;
    _full_ref_line = {};
}

void MapTaskManager::setSocketManager(SocketManager *socket_manager)
{
    _socket_manager = socket_manager;
    connect(_socket_manager, SIGNAL(mapsInfo(QJsonObject)),
            this, SLOT(parseRegionsInfo(QJsonObject)));
    connect(_socket_manager, SIGNAL(sendMapAndTasks(QJsonObject)),
            this, SLOT(parseMapAndTasksInfo(QJsonObject)));
    connect(_socket_manager, SIGNAL(currentWorkMapData(QJsonObject)),
            this, SLOT(parseCurrentWorkMapData(QJsonObject)));
    connect(_socket_manager, SIGNAL(parseMapName(QJsonObject)),
            this, SLOT(parseMapName(QJsonObject)));
    connect(_socket_manager, SIGNAL(parseWorkFullRefLineInfo(QJsonObject)),
            this, SLOT(parseWorkFullRefLineInfo(QJsonObject)));

    connect(_socket_manager, SIGNAL(setTasksRST(QJsonObject)),
            this, SLOT(setTaskCB(QJsonObject)));
    connect(_socket_manager, SIGNAL(setInitPosRST(QJsonObject)),
            this, SLOT(setInitPosCB(QJsonObject)));

    connect(_socket_manager, SIGNAL(pauseTaskRST(bool, int)),
            this, SLOT(parsePauseTask(bool, int)));
    connect(_socket_manager, SIGNAL(pauseStopTaskRST(int)), this, SLOT(parseStopTask(int)));
    connect(_socket_manager, SIGNAL(workDown(QJsonObject)), this, SLOT(parseWorkDown()));


    connect(_socket_manager, SIGNAL(enableCleanWork(bool)),
            this, SIGNAL(updateEnableCleanWork(bool)));

}

void MapTaskManager::setStatusManager(StatusManager* status_manager) {
    _status_manager = status_manager;
}

void MapTaskManager::sendInitPos(const double &pos_x, const double &pos_y)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_SET_INIT_POSE));
    obj.insert("x", pos_x);
    obj.insert("y", pos_y);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MapTaskManager::setMapName(const QString &map_name)
{
    QJsonObject obj;
    obj.insert("message_type", MESSAGE_SET_MAP);
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

QVariantList MapTaskManager::getMapRoads(const QString &map_name)
{
    if (_all_maps.empty()) {
        return QVariantList();
    }

    QJsonObject obj = _all_maps.value(map_name);
    return QJsonTransformer::ParseRoads(obj.value("roads").toObject());
}

QVariantList MapTaskManager::getTasksData(const QStringList &task_name)
{
    if (_tasks_in_map.empty()) {
        return QVariantList();
    }

    QVariantList points;
    QVariantList regions;
    QVariantList lines;

    for (int i = 0; i < task_name.size(); ++i) {
        qint8 task_type = _tasks_in_map.value(task_name.at(i)).first;
        QVariantList task_data = _tasks_in_map.value(task_name.at(i)).second;
        if (task_type == 1) {
            lines.push_back(task_data);
        } else if (task_type == 2) {
            points.push_back(task_data);
        } else if (task_type == 3) {
            regions.push_back(task_data);
        }
    }

    QVariantList tasks_list;
    tasks_list.push_back(points);
    tasks_list.push_back(regions);
    tasks_list.push_back(lines);
    return tasks_list;
}

QVariantList MapTaskManager::getMapFeature(const QString &map_name)
{
    if (_all_features.empty()) {
        return QVariantList();
    }
    QMap<QString, QJsonObject>::const_iterator iter = _all_features.find(map_name);
    if (iter == _all_features.constEnd()) {
        return QVariantList();
    }
    QJsonObject begin_obj = iter.value().value("begin_point").toObject();
    QJsonObject charge_obj = iter.value().value("charge_point").toObject();

    QVariantList map_feature;
    // TODO
    map_feature.push_back(begin_obj);
    map_feature.push_back(charge_obj);
    return map_feature;
}

QStringList MapTaskManager::getMapsName()
{
    QStringList maps_name;
    QMap<QString, QJsonObject>::const_iterator iter = _all_maps.constBegin();
    for (; iter != _all_maps.constEnd(); ++iter) {
        maps_name.push_back(iter.key());
    }
    return maps_name;
}

void MapTaskManager::setWorkTasksName(const QStringList &task_list)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_SET_TASKS));
    obj.insert("tasks_name",QJsonArray::fromStringList(task_list));
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MapTaskManager::setPauseTaskCommond(const bool is_pause)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_PAUSE_TASK));
    obj.insert("flag", is_pause);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

int MapTaskManager::getWorkStatus() {
    return int(_work_status);
}

void MapTaskManager::setWorkStatus(const int status) {
    _work_status = WorkStatus(status);
}

bool MapTaskManager::isInWorkingState()
{
    return _work_status == WORK_STATUS_WORKING;
}

void MapTaskManager::turnToSelectMap()
{
    QJsonObject obj;
    obj.insert("message_type", MESSAGE_RETURN_TO_SELECT_MAP);
    obj.insert("flag", true);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MapTaskManager::turnToSelectTask()
{
    QJsonObject obj;
    obj.insert("message_type", MESSAGE_RETURN_TO_SELECT_TASK);
    obj.insert("flag", true);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MapTaskManager::setEnableCleanWork(bool flag)
{
    QJsonObject obj;
    obj.insert("message_type", MESSAGE_ENABLE_CLEAN_WORK);
    obj.insert("flag", flag);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

//////////////////////
void MapTaskManager::parseTasksData(const QJsonObject &tasks_obj)
{
    _tasks_in_map.clear();
    if (tasks_obj.empty()) {
        return;
    }

    QJsonObject::const_iterator it;
    for(it = tasks_obj.constBegin(); it != tasks_obj.constEnd(); ++it) {
        QJsonObject temp_obj = it.value().toObject();
        QString task_name = temp_obj.value("name").toString();

        QVariantList points = temp_obj.value("points").toArray().toVariantList();
        qint8 task_type = temp_obj.value("task_type").toInt();

        QPair<qint8, QVariantList> type_point(task_type, points);
        _tasks_in_map.insert(task_name, type_point);
    }
}





void MapTaskManager::setTaskCB(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    _work_status = WORK_STATUS_MAP_SELECTED_LOCATING;
    emit setTaskInfo(status, message);
}



//void MapTaskManager::localizationInitCB(const QJsonObject &obj)
//{
//    int status = obj.value("status").toInt();
//    QString message = obj.value("message").toString();
//    emit localizationInitInfo(status, message);
//}


void MapTaskManager::parsePauseTask(const bool &is_pause, const int& status)
{
    emit updatePauseTaskInfo(is_pause, status);

}

void MapTaskManager::parseStopTask(const int &status)
{
    emit updateStopTaskInfo(status);
    if (status == 1) {
        _work_status = WORK_STATUS_NONE_WORK;
    }
}

void MapTaskManager::parseWorkDown()
{
     _work_status = WORK_STATUS_NONE_WORK;
     emit sendWorkDone();
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
    _all_maps.clear();
    QJsonObject map_obj = obj.value("maps").toObject();

    QJsonObject::Iterator it;

    for(it = map_obj.begin(); it != map_obj.end(); ++it) {
        QString map_name = it.key();
        QJsonObject map_temp_obj = it.value().toObject();
        QJsonObject area_obj = map_temp_obj.value("area").toObject();
        _map_name_list.push_back(map_name);
        _all_maps.insert(map_name, area_obj);

        QJsonObject features_obj = map_temp_obj.value("features").toObject();

        QJsonObject feature_temp_obj;
        QJsonObject begin_point_obj = features_obj.value("begin_point").toObject();
        QJsonObject charge_point_obj = features_obj.value("charge_point").toObject();
        feature_temp_obj.insert("begin_point", begin_point_obj);
        feature_temp_obj.insert("charge_point", charge_point_obj);
        _feature_obj.insert(map_name, feature_temp_obj);
    }
    if (_map_name_list.size() <= 0) {
        return;
    }
//    _work_status = WORK_STATUS_NONE_WORK;
    if(_work_status < WORK_STATUS_MAP_SELECTED_NOT_LOCATING) {
        emit updateMapsName(_map_name_list);
    }
}

void MapTaskManager::parseMapAndTasksInfo(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 1) {
        _all_maps.clear();
        _map_name_list.clear();
        QJsonObject area_obj = obj.value("area").toObject();
        QString map_name = area_obj.value("name").toString();
        _all_maps.insert(map_name, area_obj);

        _work_status = WORK_STATUS_MAP_SELECTED_LOCATING;
        _map_name_list.push_back(map_name);


        _task_data_obj = obj.value("tasks").toObject();


        this->parseTasksName(_task_data_obj);
    } else {
        emit updateErrorToLoadMapOrNoneTasksInfo(message);
        qDebug() << "[MapTaskManager::parseMapAndTasksInfo]: " << message;
    }
}

void MapTaskManager::setInitPosCB(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit updateInitPosInfo(status, message);
    _work_status = WORK_STATUS_MAP_SELECTED_NOT_LOCATING;
}

//void MapTaskManager::parseMapAndTaskInfo(const QJsonObject &obj)
//{
//    int status = obj.value("status").toInt();
//    QString message = obj.value("message").toString();
//    if (status == 1) {
//        _all_maps.clear();
//        _map_name_list.clear();
//        _work_status = WORK_STATUS_TASK_SELECTED;
//        QJsonObject area_obj = obj.value("area").toObject();
//        QString map_name = area_obj.value("name").toString();
//        _all_maps.insert(map_name, area_obj);
//        _map_name_list.push_back(map_name);


//        QJsonObject ref_line_obj = obj.value("ref_line").toObject();
//        QVariantList pts = ref_line_obj.value("pts").toArray().toVariantList();
//        _full_ref_line = pts;

//        QJsonObject cb_obj;
//        cb_obj.insert("message_type", int(MESSAGE_CURRENT_MAP_AND_TASK_RST));
//        QJsonDocument doc(cb_obj);
//        _socket_manager->sendSocketMessage(doc.toJson());

//        emit updateRefLine(_full_ref_line);
//        emit updateMapAndTaskInfo(_map_name_list.at(0));

//    } else {
//        qDebug() << "[MapTaskManager::parseMapAndTaskInfo]: " << message;
//    }
//}

void MapTaskManager::parseMapName(const QJsonObject &obj)
{
    QString map_name = obj.value("map_name").toString();
    int index = -1;

    for (int i = 0; i < _map_name_list.size(); ++ i) {
        if (_map_name_list.at(i) == map_name) {
            index = i;
            break;
        }
    }
    emit updateMapName(map_name, index);
}

void MapTaskManager::parseWorkFullRefLineInfo(const QJsonObject &obj)
{
    QJsonObject ref_line_obj = obj.value("ref_line").toObject();
    QVariantList pts = ref_line_obj.value("pts").toArray().toVariantList();
    _full_ref_line = pts;
    emit updateRefLine(_full_ref_line);
}

void MapTaskManager::parseCurrentWorkMapData(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 1) {
        _all_maps.clear();
        _map_name_list.clear();
        _work_status = WORK_STATUS_TASK_SELECTED;
        QJsonObject area_obj = obj.value("area").toObject();
        QString map_name = area_obj.value("name").toString();
        _all_maps.insert(map_name, area_obj);
        _map_name_list.push_back(map_name);

        QJsonObject cb_obj;
        cb_obj.insert("message_type", int(MessageType::MESSAGE_CURRENT_WORK_MAP_DATA_RST));
        QJsonDocument doc(cb_obj);
        _socket_manager->sendSocketMessage(doc.toJson());
        emit updateMapAndTaskInfo(_map_name_list.at(0));

    } else {
        qDebug() << "[MapTaskManager::parseCurrentWorkMapData]: " << message;
    }
}

void MapTaskManager::parseMapTasksData(const QJsonObject &obj)
{
    qint8 status = obj.value("status").toInt();
    QString message  = obj.value("message").toString();

    if (status == 0) {
        qDebug() << "[SocketManager::parseMapTasksData]: " << message;
        return;
    } else {
        QJsonObject task_data_obj = obj.value("tasks").toObject();
        this->parseTasksName(task_data_obj);
    }
}

//bool MapTaskManager::judgeIsMapTasks()
//{
//    if (_work_status == WORK_STATUS_MAP_SELECTED_LOCATING) {
//        this->parseMapData(_map_name_list.at(0));
//        this->parseTasksName(_task_data_obj);
//        emit updateMapAndTasksInfo(_map_name_list.at(0));
//        return true;
//    }
//    if (_work_status == WORK_STATUS_TASK_SELECTED) {
//        this->parseMapData(_map_name_list.at(0));
//        emit updateRefLine(_full_ref_line);
//        emit updateMapAndTaskInfo(_map_name_list.at(0));
//        return true;
//    }
//    return false;
//}

//void MapTaskManager::parseMapData(const QString &map_name)
//{
//    if (_all_maps.empty()) {
//        return;
//    }

//    QJsonObject obj = _all_maps.value(map_name);

//    QVariantList var_trees;
//    var_trees = this->parseTrees(obj);

//    QVariantList var_signals;
//    var_signals = this->parseSignals(obj);

//    QVariantList var_stop_signs;
//    var_stop_signs = this->parseStopSigns(obj);

//    QVariantList var_speed_bumps;
//    var_speed_bumps = this->parseSpeedBumps(obj);

//    QVariantList var_road_edges;
//    var_road_edges = this->parseRoadEdges(obj);

//    QVariantList var_lane_lines;
//    var_lane_lines = this->parseLaneLines(obj);

//    QList<QVariantList> var_clear_areas;
//    var_clear_areas = this->parseClearAreas(obj);
//    QVariantList var_clear_areas_include;

//    if (var_clear_areas.size() != 0) {
//        var_clear_areas_include = var_clear_areas.at(0);
//    }


//    QList<QVariantList> var_crosswalks;
//    var_crosswalks = this->parseCrosswalks(obj);
//    QVariantList var_crosswalks_include;
//    if (var_crosswalks.size() != 0) {
//        var_crosswalks_include = var_crosswalks.at(0);
//    }


//    QList<QVariantList> var_junctions;
//    var_junctions = this->parseJunctions(obj);
//    QVariantList var_junctions_include;
//    if (var_junctions.size() != 0) {
//        var_junctions_include = var_junctions.at(0);
//    }

//    QList<QVariantList> var_parking_spaces;
//    var_parking_spaces = this->parseParkingSpaces(obj);
//    QVariantList var_parking_spaces_include;
//    if (var_parking_spaces.size() != 0) {
//        var_parking_spaces_include = var_parking_spaces.at(0);
//    }

//    QList<QVariantList> var_roads;
//    var_roads = this->parseRoads(obj);
//    QVariantList var_roads_include = var_roads.at(0);
//    QVariantList var_roads_exclude;
//    if (var_roads.size() == 2) {
//        var_roads_exclude = var_roads.at(1);
//    }

//    emit updateMapData(var_trees, var_signals,
//                       var_stop_signs, var_speed_bumps,
//                       var_road_edges, var_lane_lines,
//                       var_clear_areas_include, var_crosswalks_include,
//                       var_junctions_include, var_parking_spaces_include,
//                       var_roads_include, var_roads_exclude);
//}



//QVariantList MapTaskManager::parseSignals(const QJsonObject &obj)
//{
//    QVariantList list;
//    if (obj.contains("road_signals")) {
//        QJsonObject temp_obj = obj.value("road_signals").toObject();
//        for (int i = 0; i < temp_obj.size(); ++i) {
//            QVariant pos = temp_obj.value(QString::number(i));
//            list.append(pos);
//        }
//    }
//    return list;
//}

//QVariantList MapTaskManager::parseTrees(const QJsonObject &obj)
//{
//    QVariantList list;
//    if (obj.contains("trees")) {
//        QJsonObject temp_obj = obj.value("trees").toObject();
//        for (int i = 0; i < temp_obj.size(); ++i) {
//            QVariant pos = temp_obj.value(QString::number(i));
//            list.append(pos);
//        }
//    }
//    return list;
//}

//QVariantList MapTaskManager::parseStopSigns(const QJsonObject &obj)
//{
//    QVariantList list;
//    if (obj.contains("stop_signs")) {
//        QJsonObject temp_obj = obj.value("stop_signs").toObject();
//        for (int i = 0; i < temp_obj.size(); ++i) {
//            QVariant pos = temp_obj.value(QString::number(i));
//            list.append(pos);
//        }
//    }
//    return list;
//}

//QVariantList MapTaskManager::parseSpeedBumps(const QJsonObject &obj)
//{
//    QVariantList list;
//    if (obj.contains("speed_bumps")) {
//        QJsonObject temp_obj = obj.value("speed_bumps").toObject();
//        for (int i = 0; i < temp_obj.size(); ++i) {
//            QVariant pos = temp_obj.value(QString::number(i));
//            list.append(pos);
//        }
//    }
//    return list;
//}

//QVariantList MapTaskManager::parseRoadEdges(const QJsonObject &obj)
//{
//    QVariantList list;
//    if (obj.contains("road_edges")) {
//        QJsonObject temp_obj = obj.value("road_edges").toObject();
//        for (int i = 0; i < temp_obj.size(); ++i) {
//            QJsonObject pos_obj = temp_obj.value(QString::number(i)).toObject();
//            QJsonArray temp_arr;
//            temp_arr.append(pos_obj.value("pos"));
//            temp_arr.append(pos_obj.value("type"));
//            QVariant pos = temp_arr;
//            list.append(pos);
//        }
//    }
//    return list;
//}

//QVariantList MapTaskManager::parseLaneLines(const QJsonObject &obj)
//{
//    QVariantList list;
//    if (obj.contains("lane_lines")) {
//        QJsonObject temp_obj = obj.value("lane_lines").toObject();
//        for (int i = 0; i < temp_obj.size(); ++i) {
//            QJsonObject pos_obj = temp_obj.value(QString::number(i)).toObject();
//            QJsonArray temp_arr;
//            temp_arr.append(pos_obj.value("pos"));
//            temp_arr.append(pos_obj.value("type"));
//            QVariant pos = temp_arr;
//            list.append(pos);
//        }
//    }
//    return list;
//}

//QList<QVariantList> MapTaskManager::parseClearAreas(const QJsonObject &obj)
//{
//    QList<QVariantList> list;
//    if (obj.contains("clear_areas")) {
//        QVariantList var_include;
//        QJsonObject temp_obj = obj.value("clear_areas").toObject();

//        if (temp_obj.contains("include")) {
//            QJsonObject include_obj = temp_obj.value("include").toObject();
//            for (int i = 0; i < include_obj.size(); ++i) {
//                QVariant pos = include_obj.value(QString::number(i));
//                var_include.append(pos);
//            }
//            list.append(var_include);
//        } else if (temp_obj.contains("exclude")) {
//            QVariantList var_exclude;
//            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
//            for (int i = 0; i < exclude_obj.size(); ++i) {
//                QVariant pos = exclude_obj.value(QString::number(i));
//                var_exclude.append(pos);
//            }
//            list.append(var_exclude);
//        }
//    }
//    return list;
//}

//QList<QVariantList> MapTaskManager::parseCrosswalks(const QJsonObject &obj)
//{
//    QList<QVariantList> list;
//    if (obj.contains("crosswalks")) {
//        QVariantList var_include;
//        QJsonObject temp_obj = obj.value("crosswalks").toObject();
//        if (temp_obj.contains("include")) {
//            QJsonObject include_obj = temp_obj.value("include").toObject();
//            for (int i = 0; i < include_obj.size(); ++i) {
//                QVariant pos = include_obj.value(QString::number(i));
//                var_include.append(pos);
//            }
//            list.append(var_include);
//        } else if (temp_obj.contains("exclude")) {
//            QVariantList var_exclude;
//            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
//            for (int i = 0; i < exclude_obj.size(); ++i) {
//                QVariant pos = exclude_obj.value(QString::number(i));
//                var_exclude.append(pos);
//            }
//            list.append(var_exclude);
//        }
//    }
//    return list;
//}

//QList<QVariantList> MapTaskManager::parseJunctions(const QJsonObject &obj)
//{
//    QList<QVariantList> list;
//    if (obj.contains("junctions")) {
//        QVariantList var_include;
//        QJsonObject temp_obj = obj.value("junctions").toObject();
//        if (temp_obj.contains("include")) {
//            QJsonObject include_obj = temp_obj.value("include").toObject();
//            for (int i = 0; i < include_obj.size(); ++i) {
//                QVariant pos = include_obj.value(QString::number(i));
//                var_include.append(pos);
//            }
//            list.append(var_include);
//        } else if (temp_obj.contains("exclude")) {
//            QVariantList var_exclude;
//            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
//            for (int i = 0; i < exclude_obj.size(); ++i) {
//                QVariant pos = exclude_obj.value(QString::number(i));
//                var_exclude.append(pos);
//            }
//            list.append(var_exclude);
//        }
//    }
//    return list;
//}

//QList<QVariantList> MapTaskManager::parseParkingSpaces(const QJsonObject &obj)
//{
//    QList<QVariantList> list;
//    if (obj.contains("parking_spaces")) {
//        QVariantList var_include;
//        QJsonObject temp_obj = obj.value("parking_spaces").toObject();
//        if (temp_obj.contains("include")) {
//            QJsonObject include_obj = temp_obj.value("include").toObject();
//            for (int i = 0; i < include_obj.size(); ++i) {
//                QVariant pos = include_obj.value(QString::number(i));
//                var_include.append(pos);
//            }
//            list.append(var_include);
//        } else if (temp_obj.contains("exclude")) {
//            QVariantList var_exclude;
//            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
//            for (int i = 0; i < exclude_obj.size(); ++i) {
//                QVariant pos = exclude_obj.value(QString::number(i));
//                var_exclude.append(pos);
//            }
//            list.append(var_exclude);
//        }
//    }
//    return list;
//}

//QList<QVariantList> MapTaskManager::parseRoads(const QJsonObject &obj)
//{
//    QList<QVariantList> list;
//    if (obj.contains("roads")) {
//        QVariantList var_include;
//        QJsonObject temp_obj = obj.value("roads").toObject();
//        if (temp_obj.contains("include")) {
//            QJsonObject include_obj = temp_obj.value("include").toObject();
//            for (int i = 0; i < include_obj.size(); ++i) {
//                QVariant pos = include_obj.value(QString::number(i));
//                var_include.append(pos);
//            }
//            list.append(var_include);
//        }
//        if (temp_obj.contains("exclude")) {
//            QVariantList var_exclude;
//            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
//            for (int i = 0; i < exclude_obj.size(); ++i) {
//                QVariant pos = exclude_obj.value(QString::number(i));
//                var_exclude.append(pos);
//            }
//            list.append(var_exclude);
//        }
//    }
//    return list;
//}

