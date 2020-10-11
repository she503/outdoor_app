#include "vehicle_info_manager.h"
#include <QDebug>
//#include <QtAndroidExtras/QAndroidJniObject>
//#include <QtAndroidExtras/QAndroidJniEnvironment>
//#include <QtAndroidExtras/QAndroidActivityResultReceiver>

VehicleInfoManager::VehicleInfoManager(QObject *parent) : QObject(parent)
{

//    QAndroidJniObject name = QAndroidJniObject::getStaticObjectField(
//                "android/content/Context",
//                "POWER_SERVICE",
//                "Ljava/lang/String;"
//                );
//    CHECK_EXCEPTION();
//    QAndroidJniObject powerService = activity.callObjectMethod(
//                "getSystemService",
//                "(Ljava/lang/String;)Ljava/lang/Object;",
//                name.object<jstring>());
//    CHECK_EXCEPTION();
//    QAndroidJniObject tag = QAndroidJniObject::fromString("QtJniWakeLock");
//    m_wakeLock = powerService.callObjectMethod(
//                "newWakeLock",
//                "(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;",
//                10, //SCREEN_BRIGHT_WAKE_LOCK
//                tag.object<jstring>()
//                );
//    CHECK_EXCEPTION();
//    if(m_wakeLock.isValid())
//    {
//        m_wakeLock.callMethod<void>("acquire");
//        CHECK_EXCEPTION();
//    }

}

float VehicleInfoManager::getVehicleWidth()
{
    return _max_x - _min_x;
}

float VehicleInfoManager::getVehicleHeight()
{
    return _max_y - _min_y;
}

int VehicleInfoManager::getVehicleType()
{
    return int(_vehicle_type);
}

void VehicleInfoManager::setVehicleWidth(const float width)
{
    _vehicle_width = width;
}

void VehicleInfoManager::setVehicleHeight(const float height)
{
    _vehicle_height = height;
}

void VehicleInfoManager::setVehicleType(const int type)
{
    _vehicle_type = VehicleType(type);
}
