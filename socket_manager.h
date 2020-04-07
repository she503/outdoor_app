#ifndef SOCKET_MANAGER_H
#define SOCKET_MANAGER_H

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

class SocketManager : public QObject
{
    Q_OBJECT
public:
    explicit SocketManager(QObject *parent = nullptr);
    ~SocketManager();

    bool sendSocketMessage(const QByteArray& message);

    /**
    * @brief 连接服务器
    */
    Q_INVOKABLE bool connectToHost(const QString& ip, const QString& port);

    /**
     * @brief 断开服务器
     */
    Q_INVOKABLE bool disConnet();

    /**
     * @brief 数据写入socket
     */
    Q_INVOKABLE bool sendData(const QByteArray& data);

    Q_INVOKABLE bool judgeIsConnected();
signals:
    void mapsInfo(const QJsonObject& obj);
    void sendMapAndTasks(const QJsonObject& obj);
    void sendMapAndTask(const QJsonObject& obj);
    void setMapAndInitPosRST(const QJsonObject& obj);


    void tasksData(const QJsonObject& obj);
    void setInitPosRST(const QJsonObject& obj);
    void parseMapName(const QJsonObject& obj);


    void checkoutLogin(const QJsonObject& obj);
    void addUser(const QJsonObject& obj);
    void deleteUser(const QJsonObject& obj);
    void updateUser(const QJsonObject& obj);
    void allUser(const QJsonObject& obj);

//    void localizationInitRST(const QJsonObject& obj);
    void setTasksRST(const QJsonObject& obj);

    void taskProcessInfo(const QJsonObject& obj);

    // app断开连接发出信号
    void appDisconnected(const QString& message);
    
    // 数据发送
    void sendDataToSocket(const QByteArray& data);


    //
    void localizationInfo(const QJsonObject& obj);
    void chassisInfo(const QJsonObject& obj);
    void obstaclesInfo(const QJsonObject& obj);
    void planningInfo(const QJsonObject& obj);
    void planningRefInfo(const QJsonObject& obj);
    void batteryInfo(const QJsonObject& obj);

//    /**
//     * @brief 发给ui显示的数据
//     */
//    void updateBatteryInfo(const QString& soc);
//    void updateVehicleSpeed(const QString& speed);
//    void updateWaterVolume(const QString& water_volume);
//    void updateOperateMethod(const QString& operate_method);


    //message
    void emitFaildToLogin(const QString& message);

    void pauseTaskRST(const bool& is_pause, const int& status);
    void pauseStopTaskRST(const int& status);

private slots:
    void readSocketData(/*const QByteArray& buffer*/);

private:
    QTcpSocket* _socket;
    QByteArray _buffer;
    bool _is_connected;
};

#endif // SOCKET_MANAGER_H
