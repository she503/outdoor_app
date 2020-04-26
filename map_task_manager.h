#ifndef TERGEO_APP_MAP_TASK_MANAGER_H
#define TERGEO_APP_MAP_TASK_MANAGER_H

#include <QObject>

#include "utils.h"
#include "status_manager.h"
#include "socket_manager.h"

class MapTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit MapTaskManager(QObject *parent = nullptr);

    void setSocketManager(SocketManager* socket_manager);
    void setStatusManager(StatusManager* status_manager);

    Q_INVOKABLE void sendInitPos(const double& pos_x, const double& pos_y);

    Q_INVOKABLE void setMapName(const QString& map_name);

    Q_INVOKABLE QVariantList getMapRoads(const QString& map_name);

    Q_INVOKABLE QVariantList getTasksData(const QStringList &task_name);

    Q_INVOKABLE QVariantList getMapFeature(const QString& map_name);

    Q_INVOKABLE QStringList getMapsName();

    Q_INVOKABLE void setWorkTasksName(const QStringList& task_list);

    Q_INVOKABLE void setPauseTaskCommond(const bool is_pause);

    Q_INVOKABLE int getWorkStatus();
    Q_INVOKABLE void setWorkStatus(const int status);
    Q_INVOKABLE bool isInWorkingState();

    Q_INVOKABLE void turnToSelectMap();

    Q_INVOKABLE void turnToSelectTask();

    Q_INVOKABLE void setEnableCleanWork(bool flag);

    //    Q_INVOKABLE bool judgeIsMapTasks();

private:
    void parseTasksData(const QJsonObject& tasks_obj);

signals:
    void updateErrorToLoadMapOrNoneTasksInfo(const QString& message);
    void updateInitPosInfo(const int& status, const QString& message);

    void updateMapData(const QVariantList& trees, const QVariantList& signs,
                       const QVariantList& stop_signs, const QVariantList& speed_bumps,
                       const QVariantList& road_edges, const QVariantList& lane_lines,
                       const QVariantList& clear_areas_include, const QVariantList& crosswalks,
                       const QVariantList& junctions, const QVariantList& parking_spaces,
                       const QVariantList& roads_include, const QVariantList& roads_exclude);

    void updateMapsName(const QStringList& maps_name);
    void updateReferenceLine(const QVariantList& reference_line);
    void updatePlanningPath(const QVariantList& path);
    void updatePerceptionObstacles(const QVariantList& obstacles, const bool& is_polygon);
    void updateLocalization(const QString& time, const QString& X, const QString& Y, const QString& heading,
                            const QString& state);
    void updateTasksName(const QStringList& tasks);
    void updateTaskData(const QVariantList& points, const QVariantList& regions, const QVariantList& lines);

    void updateMapFeature(const QJsonObject& begin_point, const QJsonObject& charge_point);
    void getMapInfoError(const QString& error_message);

//    void localizationInitInfo(const int& status, const QString& message);
    void setTaskInfo(const int& status, const QString& message);

    void updateRefLine(const QVariantList& ref_line);


//    void updateSetMapAndInitPosInfo(const QString& message);
    void updateMapAndTasksInfo(const QString& map_name);
    void updateMapAndTaskInfo(const QString& map_name);

    void updatePauseTaskInfo(const bool& is_pause, const int& status);
    void updateStopTaskInfo(const int& status);
    void updateMapName(const QString& map_name, const int& index);

    void sendWorkDone();

    void updateEnableCleanWork(const bool& flag);

private slots:
    void setInitPosCB(const QJsonObject& obj);

    void parseRegionsInfo(const  QJsonObject& obj);
    void parseMapAndTasksInfo(const QJsonObject& obj);
//    void parseMapAndTaskInfo(const QJsonObject& obj);
    void parseMapName(const QJsonObject& obj);
    void parseWorkFullRefLineInfo(const QJsonObject& obj);
//    void parseSetMapAndInitPosInfo(const QJsonObject& obj);
    void parseCurrentWorkMapData(const QJsonObject& obj);


    void parseMapTasksData(const QJsonObject& obj);
//    void localizationInitCB(const QJsonObject& obj);
    void setTaskCB(const QJsonObject& obj);



    void parsePauseTask(const bool& is_pause, const int &status);
    void parseStopTask(const int& status);
    void parseWorkDown();

private:
    SocketManager* _socket_manager;
    StatusManager* _status_manager;

    QMap<QString, QJsonObject> _all_maps;
    QMap<QString, QJsonObject> _all_features;

    QJsonObject _tasks_in_map;
    QStringList _tasks_name_in_map;

    QVariantList _full_ref_line;
};

#endif // MAPTASKMANAGER_H
