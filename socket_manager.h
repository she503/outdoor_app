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

class SocketManager : public QObject
{
    Q_OBJECT
public:
    explicit SocketManager(QObject *parent = nullptr);
    ~SocketManager();

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
    
    /**
     * @brief 地图点击初始化
     */
    Q_INVOKABLE bool sendClickPointPos(const QString& pos_x, const QString& pos_y);

signals:
    // app断开连接发出信号
    void appDisconnected();
    
    // 数据发送
    void sendDataToSocket(const QByteArray& data);

    /**
     * @brief 地图相关
     */
    void updateMapData(const QVariantList& trees, const QVariantList& signs,
                       const QVariantList& stop_signs, const QVariantList& speed_bumps,
                       const QVariantList& road_edges, const QVariantList& lane_lines,
                       const QVariantList& clear_areas_include, const QVariantList& crosswalks,
                       const QVariantList& junctions, const QVariantList& parking_spaces,
                       const QVariantList& roads_include, const QVariantList& roads_exclude);
    void updateReferenceLine(const QVariantList& reference_line);
    void updatePlanningPath(const QVariantList& path);
    void updatePerceptionRoadEdge(const QVariantList& road_edge);
    void updatePerceptionObstacles(const QVariantList& obstacles, const bool& is_polygon);
    void updateLocalization(const QString& time, const QString& X, const QString& Y, const QString& heading,
                            const QString& state);
    void sendpiplineFile(const QString& path, const QString& file_data);


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
    void testfunction();
    bool sendSocketMessage(const QByteArray& message);
    void parseRosInfoData(const QJsonObject& obj);

    /**
     * @brief 地图相关
     */
    void parsePiplineInfoData(const QJsonObject& obj);
    void parsePlanningPath(const QJsonObject& obj);
    void parsePerceptionObstacles(const QJsonObject& obj);
    void parsePerceptionRoadEdge(const QJsonObject& obj);
    void parseReferenceLine(const QJsonObject& obj);
    void parseMapData(const QJsonObject& obj);
    void parseLocalization(const QJsonObject& obj);
    QVariantList parseSignals(const QJsonObject &obj);
    QVariantList parseTrees(const QJsonObject &obj);
    QVariantList parseStopSigns(const QJsonObject &obj);
    QVariantList parseSpeedBumps(const QJsonObject &obj);
    QVariantList parseRoadEdges(const QJsonObject &obj);
    QVariantList parseLaneLines(const QJsonObject &obj);
    QList<QVariantList> parseClearAreas(const QJsonObject &obj);
    QList<QVariantList> parseCrosswalks(const QJsonObject &obj);
    QList<QVariantList> parseJunctions(const QJsonObject &obj);
    QList<QVariantList> parseParkingSpaces(const QJsonObject &obj);
    QList<QVariantList> parseRoads(const QJsonObject &obj);

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
