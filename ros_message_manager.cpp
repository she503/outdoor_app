#include "ros_message_manager.h"

RosMessageManager::RosMessageManager(QObject *parent) : QObject(parent)
{

}

void RosMessageManager::setSocket(SocketManager *socket)
{
    _socket = socket;
    connect(_socket, SIGNAL(localizationInfo(QJsonObject)), this, SLOT(parseLocalizationInfo(QJsonObject)));
    connect(_socket, SIGNAL(chassisInfo(QJsonObject)), this, SLOT(parseChassisInfo(QJsonObject)));
    connect(_socket, SIGNAL(obstaclesInfo(QJsonObject)), this, SLOT(parseObstacleInfo(QJsonObject)));
    connect(_socket, SIGNAL(planningInfo(QJsonObject)), this, SLOT(parsePlanningInfo(QJsonObject)));
    connect(_socket, SIGNAL(planningRefInfo(QJsonObject)), this, SLOT(parsePlanningRefInfo(QJsonObject)));
    connect(_socket, SIGNAL(taskProcessInfo(QJsonObject)), this, SLOT(parseTaskProcessInfo(QJsonObject)));
    connect(_socket, SIGNAL(batteryInfo(QJsonObject)), this, SLOT(parseBatteryInfo(QJsonObject)));
    connect(_socket, SIGNAL(trajectoryInfo(QJsonObject)), this, SLOT(parseTrajectoryInfo(QJsonObject)));
}

void RosMessageManager::parseLocalizationInfo(const QJsonObject &obj)
{
    QString time = obj.value("time").toString();
    QString x = obj.value("X").toString();
    QString y = obj.value("Y").toString();
    QString heading = obj.value("heading").toString();
    QString state = obj.value("state").toString();

    emit updateLocalizationInfo(time, x, y, heading, state);
}

void RosMessageManager::parseChassisInfo(const QJsonObject &obj)
{
    QString time = obj.value("time").toString();
    QString speed = obj.value("speed").toString();
    QString omega = obj.value("omega").toString();
    int brake_state = obj.value("brak_state").toInt();
    int drive_mode = obj.value("drive_mode").toInt();
    emit updateChassisInfo(time, speed, omega, brake_state, drive_mode);
}

void RosMessageManager::parseObstacleInfo(const QJsonObject &obj)
{
    bool is_polygon = obj.value("is_polygon").toBool();
    QVariantList obstacles = obj.value("obstacles").toArray().toVariantList();

    emit updateObstacleInfo(is_polygon, obstacles);
}

void RosMessageManager::parsePlanningInfo(const QJsonObject &obj)
{
    QVariantList planning_path = obj.value("path").toArray().toVariantList();
    emit updatePlanningInfo(planning_path);
}

void RosMessageManager::parsePlanningRefInfo(const QJsonObject &obj)
{
    QVariantList planning_path = obj.value("path").toArray().toVariantList();
    emit updatePlanningRefInfo(planning_path);
}

void RosMessageManager::parseTaskProcessInfo(const QJsonObject &obj)
{
    int current_index = obj.value("current_index").toInt();
    QString progress = obj.value("progress").toString();
    emit updateTaskProcessInfo(current_index, progress);
}

void RosMessageManager::parseBatteryInfo(const QJsonObject &obj)
{
    double soc = obj.value("soc").toDouble();
    emit updateBatteryInfo(soc);
}

void RosMessageManager::parseTrajectoryInfo(const QJsonObject &obj)
{
    QVariantList trajectory = obj.value("trajectory").toArray().toVariantList();
    emit updateTrajectoryInfo(trajectory);
}
