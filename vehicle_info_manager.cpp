#include "vehicle_info_manager.h"

VehicleInfoManager::VehicleInfoManager(QObject *parent) : QObject(parent)
{

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
