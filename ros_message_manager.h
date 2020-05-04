#ifndef TERGEO_APP_ROS_MESSAGEMANAGER_H
#define TERGEO_APP_ROS_MESSAGEMANAGER_H

#include <QObject>
#include <QDateTime>
#include "socket_manager.h"


class RosMessageManager : public QObject
{
    Q_OBJECT
public:
    explicit RosMessageManager(QObject *parent = nullptr);

    void setSocket(SocketManager *socket);

signals:
    void updateLocalizationInfo(const QString& time, const QString& x, const QString& y,
                                const QString& heading, const QString& state);
    void updateChassisInfo(const QString& time, const QString& speed, const QString& omega,
                           const int& brak_state, const int& drive_mode,
                           const int& cleaning_agency_state, const bool& water_tank_signal);
    void updateObstacleInfo(const bool& is_polygon, const QVariantList& obstacles);
    void updatePlanningInfo(const QVariantList& planning_path);
    void updatePlanningRefInfo(const QVariantList& planning_path);
    void updateTaskProcessInfo(const int& current_index, const QString& progress);
    void updateBatteryInfo(const int& soc);
    void updateTrajectoryInfo(const QVariantList& trajectory);

    void updateMonitorMessageInfo(const QVariantList& monitor_message);

private slots:
    void parseLocalizationInfo(const QJsonObject& obj);
    void parseChassisInfo(const QJsonObject& obj);
    void parseObstacleInfo(const QJsonObject& obj);
    void parsePlanningInfo(const QJsonObject& obj);
    void parsePlanningRefInfo(const QJsonObject& obj);
    void parseTaskProcessInfo(const QJsonObject& obj);
    void parseBatteryInfo(const QJsonObject& obj);
    void parseTrajectoryInfo(const QJsonObject& obj);

    void parseMonitorMessageInfo(const QJsonObject& obj);

private:
    SocketManager* _socket;
};

#endif // ROSMESSAGEMANAGER_H
