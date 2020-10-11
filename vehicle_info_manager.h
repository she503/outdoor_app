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

    Q_INVOKABLE float getVehicleMaxX() { return _max_x;}
    Q_INVOKABLE float getVehicleMaxY() { return _max_y;}
    Q_INVOKABLE float getVehicleMinX() { return _min_x;}
    Q_INVOKABLE float getVehicleMinY() { return _min_y;}

    void setVehicleWidth(const float width);
    void setVehicleHeight(const float height);
    void setVehicleType(const int type);

    void setVehicleMaxX(const float max_x) { _max_x = max_x;}
    void setVehicleMaxY(const float max_y) { _max_y = max_y;}
    void setVehicleMinX(const float min_x) { _min_x = min_x;}
    void setVehicleMinY(const float min_y) { _min_y = min_y;}


private:
    float _vehicle_width = 1.28;
    float _vehicle_height = 0.74;
    float _min_x = 0;
    float _min_y = 0;
    float _max_x = 0;
    float _max_y = 0;
    VehicleType _vehicle_type = VEHICLE_TYPE_SC65A;
};

#endif // VEHICLE_INFO_H
