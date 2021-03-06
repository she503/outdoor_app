#ifndef TERGEO_APP_TCP_MANAGER_H
#define TERGEO_APP_TCP_MANAGER_H

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
#include <QDataStream>
#include <QThread>

#include "vehicle_info_manager.h"

class SocketServer : public QObject
{
    Q_OBJECT
public:
    explicit SocketServer(QObject *parent = nullptr);
    ~SocketServer();

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
//    void emitChassisInfo(const QJsonObject& obj);
    void emitCleaningAgencyInfo(const QJsonObject& obj);
    void emitDrivingInfo(const QJsonObject& obj);
    void emitObstaclesInfo(const QJsonObject& obj);
    void emitPlanningPath(const QJsonObject& obj);
    void emitPlanningRefLine(const QJsonObject& obj);
    void emitBatteryInfo(const QJsonObject& obj);
    void emitTrajectoryInfo(const QJsonObject& obj);
    void emitMonitorMessage(const QJsonObject& obj);

    void emitEnableCleanWorkRst(const bool flag);

    //mapping
    void emitMappingCommandRst(const QJsonObject& obj);
    void emitMappingProgress(const QJsonObject& obj);
    void emitMappingFinish();
    void emitMappingMessage(const bool flag, const QString& message);
    void emitStartMappingSuccess();
    void emitTransferDataRst(const QJsonObject& obj);

    // app断开连接发出信号
    void appDisconnected(const QString& message);

    void emitConnectRst(bool rst);

private:
    void parseVehicleSize(const QJsonObject& obj);

private slots:
    void readSocketData();
    void parseSocketData(const QByteArray& buffer);

    void connectToServer(const QString& ip);
    void setVehicleInfoManager(VehicleInfoManager* vehicle_info_manager);

    void disConnet();
    void sendSocketMessage(const QByteArray& message, bool compress = false);


private:
    QTcpSocket* _socket;
    QByteArray _buffer;
    quint32 _block_size = 0;

    VehicleInfoManager* _vehicle_info_manager;
};


class TcpManager : public QObject
{
    Q_OBJECT
public:
    explicit TcpManager(QObject *parent = nullptr);
    ~TcpManager();

    Q_INVOKABLE void connectToServer(const QString& ip);

private:
    void connectFunction();

signals:
    void emitConnectToServer(const QString& ip);
    void emitDisConnect();
    void emitConnectRst(bool rst);

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
//    void emitChassisInfo(const QJsonObject& obj);
    void emitCleaningAgencyInfo(const QJsonObject& obj);
    void emitDrivingInfo(const QJsonObject& obj);
    void emitObstaclesInfo(const QJsonObject& obj);
    void emitPlanningPath(const QJsonObject& obj);
    void emitPlanningRefLine(const QJsonObject& obj);
    void emitBatteryInfo(const QJsonObject& obj);
    void emitTrajectoryInfo(const QJsonObject& obj);
    void emitMonitorMessage(const QJsonObject& obj);

    void emitEnableCleanWorkRst(const bool flag);

    //mapping
    void emitMappingCommandRst(const QJsonObject& obj);
    void emitMappingProgress(const QJsonObject& obj);
    void emitMappingFinish();
    void emitMappingMessage(const bool flag, const QString& message);
    void emitStartMappingSuccess();
    void emitTransferDataRst(const QJsonObject& obj);

    void setVehicleInfoManager(VehicleInfoManager* vehicle_info_manager);

    void emitSendSocketMessage(const QByteArray& message, bool compress);

    void appDisconnected(QString s);
private:
    SocketServer* _socket_server;
    QThread* _server_thread;
};


#endif // TERGEO_APP_TCP_MANAGER_H
