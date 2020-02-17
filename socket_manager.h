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

    Q_INVOKABLE bool connectToHost(const QString& ip, const QString& port);
    Q_INVOKABLE bool disConnet();
    Q_INVOKABLE bool sendData(const QByteArray& data);
    Q_INVOKABLE bool sendAllPower(bool flag);
    Q_INVOKABLE bool sendModulePower(bool flag, const QString& module);
    Q_INVOKABLE bool sendEmergency(bool flag);
    Q_INVOKABLE bool sendConfInfoData(const QString& file_path, const QString& conf_data, const int& write_flag);

    Q_INVOKABLE bool sendLineSpeedAndAngularSpeed(const float& line_speed, const float& angular_speed);
    Q_INVOKABLE bool sendClickPointPos(const QString& pos_x, const QString& pos_y);

    Q_INVOKABLE bool getRostopic();
    Q_INVOKABLE bool startOrStopRecord(const QString& status, const QString &data);
    Q_INVOKABLE bool getConfData(const QString& file_path);

signals:
    void appDisconnected();
    void sendDataToSocket(const QByteArray& data);

    void updateMapData(const QVariantList& trees, const QVariantList& signs,
                       const QVariantList& stop_signs, const QVariantList& speed_bumps,
                       const QVariantList& road_edges, const QVariantList& lane_lines,
                       const QVariantList& clear_areas_include, const QVariantList& crosswalks,
                       const QVariantList& junctions, const QVariantList& parking_spaces,
                       const QVariantList& roads_include, const QVariantList& roads_exclude);

    void updateChassisInfo(const QString& time, const float& speed_mps, const float& omega_radps,
                           const QString& brake, const QString& drive_button, const QString& drive_mode );
    void updateBatteryInfo(const QString& time, const float& current_battery, const float& temperature);
    void updateGpsInfo(const QString& time, const QString& B, const QString& L,
                       const QString& heading, const QString& state);

    void updateReferenceLine(const QVariantList& reference_line);
    void updateGuardianInfo(const QString& time, const QString& brake_cmd, const QString& omega_radps,
                            const QString& speed_mps, const QString& lighting, const QString& trumpet,
                            const QString& left_steer_light, const QString& right_steer_light,
                            const QString& indicator_lighting, const QString& sweeping,
                            const QString& water_pump, const QString& lifting_motor);
    void updateControlInfo(const QString& time, const QString& success,
                           const QString& omega_radps, const QString& speed_mps);
    void updatePlanningStrategy(const int& mode);
    void updatePlanningPath(const QVariantList& path);
    void updatePerceptionRoadEdge(const QVariantList& road_edge);
    void updatePerceptionObstacles(const QVariantList& obstacles, const bool& is_polygon);
    void updateBrainStatus(const int& temperature);
    void updateEmergencyStatus(const QString& emergency_status);
    void updateLocalization(const QString& time, const QString& X, const QString& Y, const QString& heading,
                            const QString& state);

    // module status
    void sendLocalizationStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendMapStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendPerceptionStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendControlStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendMonitorStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendGuardianStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendPlanningStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendVehicleStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
//    void sendLidarStatus(const bool& flag, const float& cpu_rate, const float& mem_rate);
    void sendActiveNum(const int& num);

    // send conf write status
    void sendConfWriteStatus(const QString& path, const int& write_flag);

    //send pipline file
    void sendpiplineFile(const QString& path, const QString& file_data);

    void sendRostopic(const QVariant& topic_list);
    void sendRecordStatus(const QString& record_status);

private slots:
    void readSocketData(/*const QByteArray& buffer*/);

private:

    void parseModulesStatus(const QJsonObject& obj);
    void parseConfInfoData(const QJsonObject& obj);
    void parseRosInfoData(const QJsonObject& obj);
    void parsePiplineInfoData(const QJsonObject& obj);

    void parseChassisInfo(const QJsonObject& obj);
    void parseBatteryInfo(const QJsonObject& obj);
    void parseGpsInfo(const QJsonObject& obj);
    void parseGuardianInfo(const QJsonObject& obj);
    void parsePlanningPath(const QJsonObject& obj);
    void parsePerceptionObstacles(const QJsonObject& obj);
    void parseBrainStatus(const QJsonObject& obj);
    void parsePerceptionRoadEdge(const QJsonObject& obj);
//    void parseNotification(const QJsonObject& obj);
    void parseReferenceLine(const QJsonObject& obj);
    void parseControlInfo(const QJsonObject& obj);

    void parseMapData(const QJsonObject& obj);
    void parseLocalization(const QJsonObject& obj);

    bool sendSocketMessage(const QByteArray& message);


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
};

#endif // SOCKET_MANAGER_H
