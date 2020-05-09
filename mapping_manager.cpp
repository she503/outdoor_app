#include "mapping_manager.h"

MappingManager::MappingManager(QObject *parent) : QObject(parent),
    _indoor_outdoor(MAPPING_PLACE_NULL), _mapping_status(MAPPING_STATUS_NULL)
{

}

bool MappingManager::setSocketManager(SocketManager* socket_manager)
{
    _socket_manager = socket_manager;
}

void MappingManager::setMappingStartOrStop(const int mapping_status)
{
    if (mapping_status >= 3) {
        qDebug() << "[MappingManager::setMappingStartOrStop]: _indoor_outdoor_tag.isEmpty()";
        return;
    }

//    QJsonObject obj;
//    obj.insert("message_type", int(MESSAGE_SET_INIT_POSE));
//    obj.insert("x", pos_x);
//    obj.insert("y", pos_y);
//    QJsonDocument doc(obj);
//    _socket_manager->sendSocketMessage(doc.toJson());
}
