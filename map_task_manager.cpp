#include "map_task_manager.h"
#include "qjson_transformer.h"

MapTaskManager::MapTaskManager(QObject *parent) : QObject(parent)
{

}

void MapTaskManager::setSocketManager(SocketManager *socket_manager)
{
    _socket_manager = socket_manager;


}

void MapTaskManager::setStatusManager(StatusManager* status_manager) {
    _status_manager = status_manager;
}

