#ifndef ROSMESSAGEMANAGER_H
#define ROSMESSAGEMANAGER_H

#include <QObject>
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
                           const int& brak_state, const int& drive_mode);
    void updateObstacleInfo(const bool& is_polygon, const QVariantList& obstacles);
    void updatePlanningInfo(const QVariantList& planning_path);
    void updatePlanningRefInfo(const QVariantList& planning_path);
    void updateTaskProcessInfo(const int& current_index, const QString& progress);

private slots:
    void parseLocalizationInfo(const QJsonObject& obj);
    void parseChassisInfo(const QJsonObject& obj);
    void parseObstacleInfo(const QJsonObject& obj);
    void parsePlanningInfo(const QJsonObject& obj);
    void parsePlanningRefInfo(const QJsonObject& obj);
    void parseTaskProcessInfo(const QJsonObject& obj);
private:
    SocketManager* _socket;
};

#endif // ROSMESSAGEMANAGER_H
