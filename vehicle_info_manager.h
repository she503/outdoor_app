#ifndef TERGEO_APP_VEHICLE_INFO_MANAGER_H
#define TERGEO_APP_VEHICLE_INFO_MANAGER_H

#include <QObject>

enum VehicleType {
    VEHICLE_TYPE_NULL = 0,
    VEHICLE_TYPE_SC65A = 1,
    VEHICLE_TYPE_SC65B = 2,
    VEHICLE_TYPE_SC50 = 3,

    VEHICLE_TYPE_SW210 = 100
};

class VehicleInfoManager : public QObject
{
    Q_OBJECT
public:
    explicit VehicleInfoManager(QObject *parent = nullptr);

    Q_INVOKABLE float getVehicleWidth();
    Q_INVOKABLE float getVehicleHeight();
    Q_INVOKABLE int getVehicleType();

    void setVehicleWidth(const float width);
    void setVehicleHeight(const float height);
    void setVehicleType(const int type);

private:
    float _vehicle_width = 1.28;
    float _vehicle_height = 0.74;
    VehicleType _vehicle_type = VEHICLE_TYPE_SC65A;
};

#endif // VEHICLE_INFO_H
