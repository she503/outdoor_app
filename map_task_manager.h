#ifndef MAPTASKMANAGER_H
#define MAPTASKMANAGER_H

#include <QObject>

#include "utils.h"
#include "socket_manager.h"

class MapTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit MapTaskManager(QObject *parent = nullptr);

    /**
     * @brief 地图点击初始化
     */
    Q_INVOKABLE bool sendClickPointPos(const QString& pos_x, const QString& pos_y);

    /**
      * @brief send map info by param map_name
      */
    Q_INVOKABLE void parseMapData(const QString& map_name);

    /**
      * @brief get tasks data
      */
    Q_INVOKABLE void getTasksData(const QStringList &task_name);

    /**
      * @brief get map features
      */
    Q_INVOKABLE void getFeature(const QString& map_name);

    /**
      * @brief get map tasks name
      */
    Q_INVOKABLE void getMapTask(const QString& map_name);

    /**
     * @brief get maps name
     */
    Q_INVOKABLE void getMapsName();

    /**
      * @brief choose the tasks than send them to server
      */
    Q_INVOKABLE void sentMapTasksName(const QStringList& task_list);


public:
    void setSocket(SocketManager* socket);
private:

    void parseTasksName(const QJsonObject& tasks_obj);


    QVariantList parseSignals(const QJsonObject &obj);
    QVariantList parseTrees(const QJsonObject &obj);
    QVariantList parseStopSigns(const QJsonObject &obj);
    QVariantList parseSpeedBumps(const QJsonObject &obj);
    QVariantList parseRoadEdges(const QJsonObject &obj);
    QVariantList parseLaneLines(const QJsonObject &obj);
    QList<QVariantList> parseClearAreas(const QJsonObject &obj);
    QList<QVariantList> parseCrosswalks(const QJsonObject &obj);
    QList<QVariantList> parseJunctions(const QJsonObject &obj);
    QList<QVariantList> parseParkingSpaces(const QJsonObject &obj);
    QList<QVariantList> parseRoads(const QJsonObject &obj);
signals:
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
private slots:

    void parseRegionsInfo(const  QJsonObject& obj);
    void parsseMapTasksData(const QJsonObject& obj);

private:
    SocketManager* _socket;
    QMap<QString, QJsonObject> _maps;
    QMap<QString, QPair<qint8, QVariantList>> _tasks;
    QStringList _map_name_list;
    QStringList _task_name;
    QJsonObject _feature_obj;


};

#endif // MAPTASKMANAGER_H
