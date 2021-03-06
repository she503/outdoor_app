#include "ros_message_manager.h"
#include "utils.h"

RosMessageManager::RosMessageManager(QObject *parent) : QObject(parent)
{

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

void RosMessageManager::parseCleaningAgencyInfo(const QJsonObject &obj)
{

    int cleaning_agency_state = obj.value("cleaning_agency_state").toInt();
    bool pure_water_signal = obj.value("cleanning_agency_state").toBool();
    bool water_tank_signal = obj.value("water_tank_signal").toBool();
    bool dirty_water_signal = obj.value("dirty_water_signal").toBool();
    bool cleaning_scu_signal = obj.value("cleaning_scu_signal").toBool();

    emit updateCleaningAgencyInfo(cleaning_agency_state, pure_water_signal, water_tank_signal,
                                  dirty_water_signal, cleaning_scu_signal);
}

void RosMessageManager::parseDrivingInfo(const QJsonObject &obj)
{
    QString speed = obj.value("speed").toString();
    QString omega = obj.value("omega").toString();
    int brake_state = obj.value("brak_state").toInt();
    int drive_mode = obj.value("drive_mode").toString().toInt();
    int gear_state = obj.value("gear_state").toInt();
    bool anti_collision_bar_signal = obj.value("anti_collision_bar_signal").toBool();
    bool emergency_stop_signal = obj.value("emergency_stop_signal").toBool();

    emit updateDrivingInfo(speed, omega, brake_state, drive_mode, gear_state, anti_collision_bar_signal,
                           emergency_stop_signal);
}

//void RosMessageManager::parseChassisInfo(const QJsonObject &obj)
//{
//    QString time = obj.value("time").toString();
//    QString speed = obj.value("speed").toString();
//    QString omega = obj.value("omega").toString();
//    int brake_state = obj.value("brak_state").toInt();
//    int drive_mode = obj.value("drive_mode").toInt();
//    int cleaning_agency_state = obj.value("cleaning_agency_state").toInt();
//    bool water_tank_signal = obj.value("water_tank_signal").toBool();
//    emit updateChassisInfo(time, speed, omega,
//                           brake_state, drive_mode,
//                           cleaning_agency_state,water_tank_signal);
//}

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

    if(_last_trajectory.empty()) {
        _trajectory = trajectory;
        _last_trajectory = trajectory[trajectory.size() - 1].toList();
        emit updateTrajectoryInfo(trajectory);
    } else {
        QVariantList send_trajectory = trajectory;
        send_trajectory.push_back(_last_trajectory);
        emit updateTrajectoryInfo(send_trajectory);
        _last_trajectory = trajectory[trajectory.size() - 1].toList();
    }

    QString single_mileage = QString::number(obj.value("single_mileage").toDouble() / 1000,'f', 2);
    QString total_mileage = QString::number(obj.value("total_mileage").toDouble() / 1000,'f', 2);
    emit updateMileageInfo(single_mileage, total_mileage);
}

void RosMessageManager::parseMonitorMessageInfo(const QJsonObject &obj)
{
    QDateTime time_secs = QDateTime::fromTime_t(obj.value("time").toDouble());
    QString str_time = time_secs.toString("hh:mm:ss");

    QJsonObject monitor_messages_obj = obj.value("monitor_messages").toObject();
    if (monitor_messages_obj.empty()) {
        return;
    }
    QJsonObject::const_iterator it = monitor_messages_obj.begin();
    QVariantList error_list;

    while (it != monitor_messages_obj.end()) {
        QJsonObject temp_obj = it.value().toObject();
        QString error_code = temp_obj.value("error_code").toString();
        QString error_message = temp_obj.value("error_message").toString();
        QString error_level = QString::number(temp_obj.value("error_level").toInt());

        QVariantList temp_list = { str_time ,error_level, error_code, error_message};
        error_list.push_back(temp_list);
        ++it;
    }

    emit updateMonitorMessageInfo(error_list);
}
