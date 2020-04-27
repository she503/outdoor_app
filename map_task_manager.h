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

    Q_INVOKABLE void setWorkMapName(const QString& map_name);

    Q_INVOKABLE QVariantList getMapRoads(const QString& map_name);

    Q_INVOKABLE QVariantList getTasksData(const QStringList &tasks_name);

    Q_INVOKABLE QVariantList getMapFeature(const QString& map_name);

    Q_INVOKABLE QStringList getMapsName();

    Q_INVOKABLE QString getCurrentMapName();

    Q_INVOKABLE QStringList getTasksName();

    Q_INVOKABLE void setWorkTasksName(const QStringList& task_list);

    Q_INVOKABLE void setPauseTaskCommond(const bool is_pause);

    Q_INVOKABLE void turnToSelectMap();

    Q_INVOKABLE void turnToSelectTask();

    Q_INVOKABLE void setEnableCleanWork(bool flag);

private slots:
    void parseAllMapsInfo(const QJsonObject& obj);
    void parseSetMapNameRst(const QJsonObject& obj);
    void parseSetInitPoseRst(const QJsonObject& obj);
    void parseMapAndTasksInfo(const QJsonObject& obj);
    void parseSetTasksRst(const QJsonObject& obj);
    void parseWorkMapInfo(const QJsonObject& obj);
    void parseWorkRefLineInfo(const QJsonObject& obj);

    void parsePauseTaskRst(const QJsonObject &obj);
    void parseWorkDoneInfo(const QJsonObject& obj);

signals:
    void emitGetAllMapsInfoError(const QString& error_message);
    void emitSetMapNameRstInfo(const int& status, const QString& message);
    void emitSetInitPoseRstInfo(const int& status, const QString& message);
    void emitGetMapAndTasksInfoError(const QString& error_message);
    void emitSetTasksRstInfo(const int& status, const QString& message);
    void emitGetWorkMapInfoError(const QString& error_message);
    void emitGetWorkRefLineInfoError(const QString& error_message);

    void emitWorkFullRefLine(const QVariantList& ref_line);

    void emitPauseTaskRst(const bool is_pause, const int status);
    void emitWorkDone();

private:
    SocketManager* _socket_manager;
    StatusManager* _status_manager;

    QMap<QString, QJsonObject> _all_maps;
    QMap<QString, QJsonObject> _all_features;

    QString _current_map_name;
    QMap<QString, QJsonObject> _all_tasks_in_map;
};

#endif // MAPTASKMANAGER_H
