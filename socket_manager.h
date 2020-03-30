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

    void testfunction();
signals:
    void tasksData(const QJsonObject& obj);
    void mapsInfo(const QJsonObject& obj);
    void checkoutLogin(const QJsonObject& obj);
    void addUser(const QJsonObject& obj);
    void deleteUser(const QJsonObject& obj);
    void updateUser(const QJsonObject& obj);
    void allUser(const QJsonObject& obj);

    // app断开连接发出信号
    void appDisconnected();
    
    // 数据发送
    void sendDataToSocket(const QByteArray& data);



    /**
     * @brief 发给ui显示的数据
     */
    void updateBatteryInfo(const QString& soc);
    void updateVehicleSpeed(const QString& speed);
    void updateWaterVolume(const QString& water_volume);
    void updateOperateMethod(const QString& operate_method);


private slots:
    void readSocketData(/*const QByteArray& buffer*/);



private:
    QTcpSocket* _socket;
    QByteArray _buffer;


    /**
     * @brief test
     */
    int soc;
    int speed;
    int water_volume;
    int operate_method;
};

#endif // SOCKET_MANAGER_H
