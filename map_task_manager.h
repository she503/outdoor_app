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

    Q_INVOKABLE void sendInitPos();

    Q_INVOKABLE void setInitPos(const double& pos_x, const double& pos_y, const double theta);

    Q_INVOKABLE void setWorkMapName(const QString& map_name, const int map_index);

    Q_INVOKABLE QVariantList getMapRoads(const QString& map_name);

    Q_INVOKABLE QVariantList getMapRoadEdges(const QString& map_name);

    Q_INVOKABLE QVariantList getTasksData(const QStringList &tasks_name);

    Q_INVOKABLE QVariantList getMapFeature(const QString& map_name);

    Q_INVOKABLE QStringList getMapsName();

    Q_INVOKABLE QString getCurrentMapName();

    Q_INVOKABLE int getCurrentMapIndex();

    Q_INVOKABLE QStringList getTasksName();

    Q_INVOKABLE QVariantList getWorkFullRefLine() { return _work_full_ref_line;}

    Q_INVOKABLE void setWorkTasksName(const QStringList& task_list);

    Q_INVOKABLE void setPauseTaskCommond(const bool is_pause);

    Q_INVOKABLE void turnToSelectMap();

    Q_INVOKABLE void turnToSelectTask();

    Q_INVOKABLE void setEnableCleanWork(bool flag);

    Q_INVOKABLE void setInitIsRight(bool flag);

private slots:
    void parseAllMapsInfo(const QJsonObject& obj);
    void parseSetMapNameRst(const QJsonObject& obj);
    void parseSetInitPoseRst(const QJsonObject& obj);
    void parseMapAndTasksInfo(const QJsonObject& obj);
    void parseSetTasksRst(const QJsonObject& obj);
    void parseWorkMapInfo(const QJsonObject& obj);
    void parseWorkRefLineInfo(const QJsonObject& obj);

    void parsePauseTaskRst(const QJsonObject &obj);
    void parseWorkDoneInfo();

signals:
    void emitGetAllMapsInfoError(const QString& error_message);
    void emitSetMapNameRstInfo(const int& status, const QString& error_message);
    void emitSetInitPoseRstInfo(const int& status, const QString& error_message);
    void emitGetMapAndTasksInfoError(const QString& error_message);
    void emitSetTasksRstInfo(const int& status, const QString& error_message);
    void emitGetWorkMapInfoError(const QString& error_message);
    void emitGetWorkRefLineInfoError(const QString& error_message);

    void emitWorkFullRefLine(const QVariantList& ref_line);

    void emitPauseTaskRst(const bool is_pause, const int status);
    void emitWorkDone();

    void emitLocalizationInfo(const double x, const double y, const double heading_angle);


private:
    SocketManager* _socket_manager;
    StatusManager* _status_manager;

    QMap<QString, QJsonObject> _all_maps;
    QMap<QString, QJsonObject> _all_features;

    QString _current_map_name;
    int _current_map_index;
    QMap<QString, QJsonObject> _all_tasks_in_map;

    QVariantList _work_full_ref_line;

    QVariantList _init_pose;
};

#endif // MAPTASKMANAGER_H
