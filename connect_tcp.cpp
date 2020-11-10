#include "connect_tcp.h"

ConnectTcp::ConnectTcp(QObject *parent) : QObject(parent)
{

}

void ConnectTcp::setEngine(QQmlApplicationEngine &engine)
{
    VehicleInfoManager* vehicle_info_manager = new VehicleInfoManager(&engine);
    engine.rootContext()->setContextProperty("vehicle_info_manager", vehicle_info_manager);

    StatusManager* status_manager = new StatusManager(&engine);
    engine.rootContext()->setContextProperty("status_manager", status_manager);

    TcpManager* socket_manager = new TcpManager(&engine);
    engine.rootContext()->setContextProperty("socket_manager", socket_manager);
    socket_manager->setVehicleInfoManager(vehicle_info_manager);

    AccountManager* account_manager = new AccountManager(&engine);
    engine.rootContext()->setContextProperty("account_manager", account_manager);
//    account_manager->setSocket(socket_manager);

    connect(socket_manager, SIGNAL(emitLoginRst(QJsonObject)),
            account_manager, SLOT(parseLoginRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitAddUserRst(QJsonObject)),
            account_manager, SLOT(parseAddRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitDeleteUserRst(QJsonObject)),
            account_manager, SLOT(parseDeleteRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitUpdateUserRst(QJsonObject)),
            account_manager, SLOT(parseUpdateRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitAllAccountsInfo(QJsonObject)),
            account_manager, SLOT(parseAllAccountsInfo(QJsonObject)));

    connect(account_manager, SIGNAL(emitSendSocketMessage(QByteArray, bool)),
            socket_manager, SIGNAL(emitSendSocketMessage(QByteArray,bool)));

    MapTaskManager* map_task_manager = new MapTaskManager(&engine);
    engine.rootContext()->setContextProperty("map_task_manager", map_task_manager);
    map_task_manager->setStatusManager(status_manager);
    connect(socket_manager, SIGNAL(emitAllMapsInfo(QJsonObject)),
            map_task_manager, SLOT(parseAllMapsInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitMapAndTasks(QJsonObject)),
            map_task_manager, SLOT(parseMapAndTasksInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitCurrentWorkMapData(QJsonObject)),
            map_task_manager, SLOT(parseWorkMapInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitFullRefLine(QJsonObject)),
            map_task_manager, SLOT(parseWorkRefLineInfo(QJsonObject)));

    connect(socket_manager, SIGNAL(emitSetMapNameRst(QJsonObject)),
            map_task_manager, SLOT(parseSetMapNameRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitSetInitPosRST(QJsonObject)),
            map_task_manager, SLOT(parseSetInitPoseRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitSetTasksRST(QJsonObject)),
            map_task_manager, SLOT(parseSetTasksRst(QJsonObject)));

    connect(socket_manager, SIGNAL(emitPauseTaskRST(QJsonObject)),
            map_task_manager, SLOT(parsePauseTaskRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitWorkDone(QJsonObject)),
            map_task_manager, SLOT(parseWorkDoneInfo()));

    connect(map_task_manager, SIGNAL(emitSendSocketMessage(QByteArray, bool)),
            socket_manager, SIGNAL(emitSendSocketMessage(QByteArray,bool)));

    RosMessageManager* ros_message_manager = new RosMessageManager(&engine);
    engine.rootContext()->setContextProperty("ros_message_manager", ros_message_manager);
    connect(socket_manager, SIGNAL(emitLocalizationInfo(QJsonObject)),
            ros_message_manager, SLOT(parseLocalizationInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitCleaningAgencyInfo(QJsonObject)),
            ros_message_manager, SLOT(parseCleaningAgencyInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitDrivingInfo(QJsonObject)),
            ros_message_manager, SLOT(parseDrivingInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitObstaclesInfo(QJsonObject)),
            ros_message_manager, SLOT(parseObstacleInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitPlanningPath(QJsonObject)),
            ros_message_manager, SLOT(parsePlanningInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitPlanningRefLine(QJsonObject)),
            ros_message_manager, SLOT(parsePlanningRefInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitTaskInfo(QJsonObject)),
            ros_message_manager, SLOT(parseTaskProcessInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitBatteryInfo(QJsonObject)),
            ros_message_manager, SLOT(parseBatteryInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitTrajectoryInfo(QJsonObject)),
            ros_message_manager, SLOT(parseTrajectoryInfo(QJsonObject)));
    connect(socket_manager, SIGNAL(emitMonitorMessage(QJsonObject)),
            ros_message_manager, SLOT(parseMonitorMessageInfo(QJsonObject)));

    MappingManager* mapping_manager = new MappingManager(&engine);
    connect(socket_manager, SIGNAL(emitMappingCommandRst(QJsonObject)),
            mapping_manager, SLOT(parseMappingCommandRst(QJsonObject)));
    connect(socket_manager, SIGNAL(emitMappingProgress(QJsonObject)),
            mapping_manager, SLOT(parseMappingProgress(QJsonObject)));
    connect(socket_manager, SIGNAL(emitMappingFinish()),
            mapping_manager, SIGNAL(emitMappingFinish()));
    connect(socket_manager, SIGNAL(emitTransferDataRst(QJsonObject)),
            mapping_manager, SLOT(parseTransferDataRst(QJsonObject)));
    connect(mapping_manager, SIGNAL(emitSendSocketMessage(QByteArray, bool)),
            socket_manager, SIGNAL(emitSendSocketMessage(QByteArray,bool)));
    engine.rootContext()->setContextProperty("mapping_manager", mapping_manager);
}



