#ifndef TERGEO_APP_SOCKET_MANAGER_H
#define TERGEO_APP_SOCKET_MANAGER_H

#include <QObject>
#include <QTcpSocket>
#include <QPolygonF>
#include <QMutex>

#include <QJsonDocument>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QMap>

#include "vehicle_info_manager.h"

class SocketManager : public QObject
{
    Q_OBJECT
public:
    explicit SocketManager(QObject *parent = nullptr);
    ~SocketManager();

    Q_INVOKABLE bool connectToServer(const QString& ip);

    Q_INVOKABLE bool disConnet();

    bool sendSocketMessage(const QByteArray& message);

    void setVehicleInfoManager(VehicleInfoManager* vehicle_info_manager);

signals:
    void emitLoginRst(const QJsonObject& obj);
    void emitAddUserRst(const QJsonObject& obj);
    void emitDeleteUserRst(const QJsonObject& obj);
    void emitUpdateUserRst(const QJsonObject& obj);
    void emitAllAccountsInfo(const QJsonObject& obj);

    void emitAllMapsInfo(const QJsonObject& obj);
    void emitSetInitPosRST(const QJsonObject& obj);
    void emitMapAndTasks(const QJsonObject& obj);
    void emitCurrentWorkMapData(const QJsonObject& obj);
    void emitFullRefLine(const QJsonObject& obj);
    void emitSetMapNameRst(const QJsonObject& obj);
    void emitSetTasksRST(const QJsonObject& obj);
    void emitPauseTaskRST(QJsonObject);
    void emitWorkDone(const QJsonObject& obj);
    void emitWorkError(const QJsonObject& obj);

    // ros msgs
    void emitLocalizationInfo(const QJsonObject& obj);
    void emitTaskInfo(const QJsonObject& obj);
    void emitChassisInfo(const QJsonObject& obj);
    void emitObstaclesInfo(const QJsonObject& obj);
    void emitPlanningPath(const QJsonObject& obj);
    void emitPlanningRefLine(const QJsonObject& obj);
    void emitBatteryInfo(const QJsonObject& obj);
    void emitTrajectoryInfo(const QJsonObject& obj);
    void emitMonitorMessage(const QJsonObject& obj);

    void emitEnableCleanWorkRst(const bool flag);

    void emitMappingCommandRst(const QJsonObject& obj);

    // app断开连接发出信号
    void appDisconnected(const QString& message);



private:
    void parseVehicleSize(const QJsonObject& obj);

private slots:
    void readSocketData();
    void parseSocketData(const QByteArray& buffer);

private:
    QTcpSocket* _socket;
    QByteArray _buffer;

    VehicleInfoManager* _vehicle_info_manager;
};

#endif // SOCKET_MANAGER_H
