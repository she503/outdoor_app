#include "vehicle_info_manager.h"
//#include <QtAndroidExtras/QAndroidJniObject>
//#include <QtAndroidExtras/QAndroidJniEnvironment>
//#include <QtAndroidExtras/QAndroidActivityResultReceiver>

VehicleInfoManager::VehicleInfoManager(QObject *parent) : QObject(parent)
{
//    QAndroidJniEnvironment env;
//        QAndroidJniObject activity = androidActivity();
//        QAndroidJniObject contentResolver = activity.callObjectMethod(
//                    "getContentResolver",
//                    "()Landroid/content/ContentResolver;"
//                    );
////        CHECK_EXCEPTION();

////    QAndroidJniObject brightnessTag = QAndroidJniObject::fromString("screen_brightness");
//        QAndroidJniObject brightnessModeTag = QAndroidJniObject::fromString("screen_brightness_mode");
//        bool ok = QAndroidJniObject::callStaticMethod<jboolean>(
//                    "android/provider/Settings$System",
//                    "putInt",
//                    "(Landroid/content/ContentResolver;Ljava/lang/String;I)Z",
//                    contentResolver.object<jobject>(),
//                    brightnessModeTag.object<jstring>(),
//                    0
//                    );
////        CHECK_EXCEPTION();
}

float VehicleInfoManager::getVehicleWidth()
{
    return _vehicle_width;
}

float VehicleInfoManager::getVehicleHeight()
{
    return _vehicle_height;
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
