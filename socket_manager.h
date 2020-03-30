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
    
    /**
     * @brief 地图点击初始化
     */
    Q_INVOKABLE bool sendClickPointPos(const QString& pos_x, const QString& pos_y);

    /**
      * @brief send map info by param map_name
      */
    Q_INVOKABLE void parseMapData(const QString& map_name);

    Q_INVOKABLE void getTasksData(const QStringList &task_name);



    Q_INVOKABLE void getMapTask(const QString& map_name);
    /**
     * @brief get maps name
     */
    Q_INVOKABLE void getMapsName();

    Q_INVOKABLE void sentMapTasksName(const QStringList& task_list);
    Q_INVOKABLE void getFeature(const QString& map_name);

    Q_INVOKABLE void accountLogin(const QString& username, const QString& password);
    Q_INVOKABLE void accountAdd(const QString& username, const QString& password, const int& level);
    Q_INVOKABLE void getAllAccounts();
    Q_INVOKABLE void accountDelete(const QString& username);
    Q_INVOKABLE void accountUpdate(const QString& username, const QString& password, const int& level);

signals:
    void checkoutLogin(const QJsonObject& obj);
    // login about
    void emitCheckOutLogin(const int& status, const QString& message);
    void emitAllAccountInfo(const QJsonObject& accounts_info);
    void emitAddAccountCB(const int& status, const QString& message);
    void emitDeleteAccountCB(const int& status, const QString& message);
    void emitUpdateAccountCB(const int& status, const QString& message);

    // app断开连接发出信号
    void appDisconnected();
    
    // 数据发送
    void sendDataToSocket(const QByteArray& data);


    /**
     * @brief 地图相关
     */
    void updateMapsName(const QStringList& maps_name);
    void updateMapData(const QVariantList& trees, const QVariantList& signs,
                       const QVariantList& stop_signs, const QVariantList& speed_bumps,
                       const QVariantList& road_edges, const QVariantList& lane_lines,
                       const QVariantList& clear_areas_include, const QVariantList& crosswalks,
                       const QVariantList& junctions, const QVariantList& parking_spaces,
                       const QVariantList& roads_include, const QVariantList& roads_exclude);
    void updateReferenceLine(const QVariantList& reference_line);
    void updatePlanningPath(const QVariantList& path);
//    void updatePerceptionRoadEdge(const QVariantList& road_edge);
    void updatePerceptionObstacles(const QVariantList& obstacles, const bool& is_polygon);
    void updateLocalization(const QString& time, const QString& X, const QString& Y, const QString& heading,
                            const QString& state);


    /**
     * @brief 发给ui显示的数据
     */
    void updateBatteryInfo(const QString& soc);
    void updateVehicleSpeed(const QString& speed);
    void updateWaterVolume(const QString& water_volume);
    void updateOperateMethod(const QString& operate_method);

    void getMapInfoError(const QString& error_message);

    void updateTasksName(const QStringList& tasks);
    void updateTaskData(const QVariantList& points, const QVariantList& regions, const QVariantList& lines);

    void updateMapFeature(const QJsonObject& begin_point, const QJsonObject& charge_point);
private slots:
    void readSocketData(/*const QByteArray& buffer*/);

private:
    //map
    void getAllAccountInfo(const QJsonObject& obj);


    void testfunction();

    void parseRosInfoData(const QJsonObject& obj);

    //login about
    void checkOutLogin(const QJsonObject& obj);
    void parserAddStatus(const QJsonObject& obj);
    void parseDeleteStatus(const QJsonObject& obj);
    void parseUpdateStatus(const QJsonObject& obj);
    void parseAllAccountsInfo(const QJsonObject& obj);


    /**
      * @brief get maps tasks
      */
    void parseTasksName(const QJsonObject& tasks_obj);

    /**
     * @brief 地图相关
     */
//    void parsePlanningPath(const QJsonObject& obj);
//    void parsePerceptionObstacles(const QJsonObject& obj);
//    void parsePerceptionRoadEdge(const QJsonObject& obj);
//    void parseReferenceLine(const QJsonObject& obj);
//    void parseLocalization(const QJsonObject& obj);

    void parseRegionsInfo(const  QJsonObject& obj);
    void parsseMapTasksData(const QJsonObject& obj);


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
    QMap<QString, QJsonObject> _maps;
    QMap<QString, QPair<qint8, QVariantList>> _tasks;
    QStringList _map_name_list;
    QStringList _task_name;

    QJsonObject _all_accounts_obj;
    QJsonObject _feature_obj;

    /**
     * @brief test
     */
    int soc;
    int speed;
    int water_volume;
    int operate_method;
};

#endif // SOCKET_MANAGER_H
