#include "map_task_manager.h"
#include "qjson_transformer.h"

MapTaskManager::MapTaskManager(QObject *parent) : QObject(parent),_work_full_ref_line({})
{

}

void MapTaskManager::setSocketManager(SocketManager *socket_manager)
{
    _socket_manager = socket_manager;
    connect(_socket_manager, SIGNAL(emitAllMapsInfo(QJsonObject)),
            this, SLOT(parseAllMapsInfo(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitMapAndTasks(QJsonObject)),
            this, SLOT(parseMapAndTasksInfo(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitCurrentWorkMapData(QJsonObject)),
            this, SLOT(parseWorkMapInfo(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitFullRefLine(QJsonObject)),
            this, SLOT(parseWorkRefLineInfo(QJsonObject)));

    connect(_socket_manager, SIGNAL(emitSetMapNameRst(QJsonObject)),
            this, SLOT(parseSetMapNameRst(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitSetInitPosRST(QJsonObject)),
            this, SLOT(parseSetInitPoseRst(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitSetTasksRST(QJsonObject)),
            this, SLOT(parseSetTasksRst(QJsonObject)));

    connect(_socket_manager, SIGNAL(emitPauseTaskRST(QJsonObject)),
            this, SLOT(parsePauseTaskRst(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitWorkDone(QJsonObject)),
            this, SLOT(parseWorkDoneInfo()));
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

void MapTaskManager::setWorkMapName(const QString &map_name)
{
    QJsonObject obj;
    obj.insert("message_type", MESSAGE_SET_MAP);
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

QVariantList MapTaskManager::getMapRoads(const QString &map_name)
{
    if (_all_maps.empty() || map_name == "") {
        return QVariantList();
    }

    QJsonObject obj = _all_maps.value(map_name);
    return QJsonTransformer::ParseRoads(obj.value("roads").toObject());
}

QVariantList MapTaskManager::getMapRoadEdges(const QString &map_name)
{
    if (_all_maps.empty()) {
        return QVariantList();
    }

    QJsonObject obj = _all_maps.value(map_name);
    return QJsonTransformer::ParseRoadEdges(obj.value("road_edges").toObject());
}

QVariantList MapTaskManager::getTasksData(const QStringList &tasks_name)
{
    if (_all_tasks_in_map.empty()) {
        return QVariantList();
    }

    QVariantList goal_tasks;
    QVariantList cover_tasks;
    QVariantList track_tasks;

    for (int i = 0; i < tasks_name.size(); ++i) {
        QMap<QString, QJsonObject>::const_iterator iter =
                _all_tasks_in_map.find(tasks_name[i]);
        if (iter  == _all_tasks_in_map.constEnd()) {
            continue;
        }
        QVariantList points = iter.value().value("points").toArray().toVariantList();
        qint8 task_type = iter.value().value("task_type").toInt();
        if (task_type == 1) {
            track_tasks.push_back(points);
        } else if (task_type == 2) {
            goal_tasks.push_back(points);
        } else if (task_type == 3) {
            cover_tasks.push_back(points);
        }
    }

    QVariantList tasks_list;
    tasks_list.push_back(track_tasks);
    tasks_list.push_back(goal_tasks);
    tasks_list.push_back(cover_tasks);
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

QString MapTaskManager::getCurrentMapName()
{
    return _current_map_name;
}

QStringList MapTaskManager::getTasksName()
{
    QStringList tasks_name;
    QMap<QString, QJsonObject>::const_iterator iter = _all_tasks_in_map.constBegin();
    for (; iter != _all_tasks_in_map.constEnd(); ++iter) {
        tasks_name.push_back(iter.key());
    }
    return tasks_name;
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

/// \brief parse map and task info from server
void MapTaskManager::parseAllMapsInfo(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    if (status == 0) {
        QString error_message = obj.value("message").toString();
        qDebug() << "[SocketManager::parseRegionsInfo]: " << error_message;
        emit emitGetAllMapsInfoError(error_message);
        _status_manager->setWorkStatus(WORK_STATUS_NULL);
        return;
    }

    _all_maps.clear();
    _all_features.clear();
    QJsonObject map_obj = obj.value("maps").toObject();
    QJsonObject::Iterator it;
    for(it = map_obj.begin(); it != map_obj.end(); ++it) {
        QString map_name = it.key();
        QJsonObject map_temp_obj = it.value().toObject();
        QJsonObject area_obj = map_temp_obj.value("area").toObject();
        _all_maps.insert(map_name, area_obj);

        QJsonObject features_obj = map_temp_obj.value("features").toObject();
        QJsonObject feature_temp_obj;
        QJsonObject begin_point_obj = features_obj.value("begin_point").toObject();
        QJsonObject charge_point_obj = features_obj.value("charge_point").toObject();
        feature_temp_obj.insert("begin_point", begin_point_obj);
        feature_temp_obj.insert("charge_point", charge_point_obj);
        _all_features.insert(map_name, feature_temp_obj);
    }
    _current_map_name = _all_maps.firstKey();

    this->setWorkMapName(_current_map_name);
    _status_manager->setWorkStatus(WORK_STATUS_NONE_WORK);
}

void MapTaskManager::parseSetMapNameRst(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 0) {
        emit emitSetMapNameRstInfo(status, message);
    }
}

void MapTaskManager::parseSetInitPoseRst(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 0) {
        emit emitSetInitPoseRstInfo(status, message);
    }
}

void MapTaskManager::parseMapAndTasksInfo(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 0) {
        emit emitGetMapAndTasksInfoError(message);
        qDebug() << "[MapTaskManager::parseMapAndTasksInfo]: " << message;
        return;
    }

    QJsonObject area_obj = obj.value("area").toObject();
    QString map_name = area_obj.value("name").toString();
    _all_maps[map_name] = area_obj;
    _current_map_name = map_name;

    QJsonObject tasks_obj = obj.value("tasks").toObject();
    _all_tasks_in_map.clear();
    QJsonObject::const_iterator it;
    for(it = tasks_obj.constBegin(); it != tasks_obj.constEnd(); ++it) {
        QJsonObject temp_obj = it.value().toObject();
        QString task_name = temp_obj.value("name").toString();
        _all_tasks_in_map.insert(task_name, temp_obj);
    }

    _status_manager->setWorkStatus(WORK_STATUS_SELECTING_TASK);
}

void MapTaskManager::parseSetTasksRst(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 0) {
        emit emitSetTasksRstInfo(status, message);
    }
}

void MapTaskManager::parseWorkMapInfo(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 0) {
        emit emitGetWorkMapInfoError(message);
        return;
    }

    QJsonObject area_obj = obj.value("area").toObject();
    QString map_name = area_obj.value("name").toString();
    _all_maps[map_name] = area_obj;
    _current_map_name = map_name;

    _status_manager->setWorkStatus(WORK_STATUS_WORKING);

    QJsonObject cb_obj;
    cb_obj.insert("message_type", int(MessageType::MESSAGE_CURRENT_WORK_MAP_DATA_RST));
    QJsonDocument doc(cb_obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MapTaskManager::parseWorkRefLineInfo(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    if (status == 0) {
        emit emitGetWorkRefLineInfoError(message);
        return;
    }

    QJsonObject ref_line_obj = obj.value("ref_line").toObject();
    QVariantList ref_line = ref_line_obj.value("pts").toArray().toVariantList();
    _work_full_ref_line = ref_line;
    emit emitWorkFullRefLine(ref_line);
}

void MapTaskManager::parsePauseTaskRst(const QJsonObject &obj)
{
    emit emitPauseTaskRst(obj.value("current_status").toBool(),
                          obj.value("status").toInt());
}

void MapTaskManager::parseWorkDoneInfo()
{
    emit emitWorkDone();
    _status_manager->setWorkStatus(WORK_STATUS_WORK_DONE);
}
