#include "mapping_manager.h"

MappingManager::MappingManager(QObject *parent) : QObject(parent),
    _indoor_outdoor(MAPPING_PLACE_NULL), _mapping_command(MAPPING_COMMAND_NULL)
{

}

bool MappingManager::setSocketManager(SocketManager* socket_manager)
{
    _socket_manager = socket_manager;
    connect(_socket_manager, SIGNAL(emitMappingCommandRst(QJsonObject)),
            this, SLOT(parseMappingCommandRst(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitMappingProgress(QJsonObject)),
            this, SLOT(parseMappingProgress(QJsonObject)));
    connect(_socket_manager, SIGNAL(emitMappingFinish()),
            this, SIGNAL(emitMappingFinish()));
}

void MappingManager::setIndoorOutdoor(const int indoor_outdoor, const QString& map_name)
{
    _indoor_outdoor = (MappingPlace)indoor_outdoor;
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_MAPPING_PLACE));
    obj.insert("place", _indoor_outdoor);
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MappingManager::setMappingCommand(const int mapping_command)
{
    if (_indoor_outdoor >= 3) {
        qDebug() << "[MappingManager::setMappingStartOrStop]: _indoor_outdoor_tag.isEmpty()";
        return;
    }
    _mapping_command = (MappingCommand)mapping_command;
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_MAPPING_COMMAND));
    obj.insert("command", _mapping_command);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MappingManager::transferMappingData(const int key, const QString& map_name)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_MAPPING_TRANSFER_DATA));
    obj.insert("key", key);
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    _socket_manager->sendSocketMessage(doc.toJson());
}

void MappingManager::parseMappingCommandRst(const QJsonObject &obj)
{
    bool success = obj.value("success").toBool();
    QString message = obj.value("message").toString();
    emit emitMappingCommandInfo(success, message);
}

void MappingManager::parseMappingProgress(const QJsonObject &obj)
{
    int progress = obj.value("progress").toInt();
    QString message = obj.value("message").toString();
    int status = obj.value("status").toInt();

    QJsonObject pose_obj = obj.value("pose").toObject();
    double x = pose_obj.value("x").toDouble();
    double y = pose_obj.value("y").toDouble();
    double heading_angle = pose_obj.value("heading_angle").toDouble();

    emit emitmappingProgressInfo(status, message, progress, x, y, heading_angle);
}
