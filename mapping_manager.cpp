#include "mapping_manager.h"

MappingManager::MappingManager(QObject *parent) : QObject(parent),
    _indoor_outdoor(MAPPING_PLACE_NULL), _mapping_command(MAPPING_COMMAND_NULL)
{

}

void MappingManager::setIndoorOutdoor(const int indoor_outdoor, const QString& map_name)
{
    _indoor_outdoor = (MappingPlace)indoor_outdoor;
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_MAPPING_PLACE));
    obj.insert("place", _indoor_outdoor);
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    emit emitSendSocketMessage(doc.toJson(), false);
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
    emit emitSendSocketMessage(doc.toJson(), false);
}

void MappingManager::transferMappingData(const int key, const QString& map_name)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_MAPPING_TRANSFER_DATA));
    obj.insert("key", key);
    obj.insert("map_name", map_name);
    QJsonDocument doc(obj);
    emit emitSendSocketMessage(doc.toJson(), false);
}

void MappingManager::recordMappingBag(const int status)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_RECORD_ROS_BAG));

    obj.insert("status", QString::number(status));

    QJsonDocument doc(obj);
    emit emitSendSocketMessage(doc.toJson(), false);
}

void MappingManager::parseMappingCommandRst(const QJsonObject &obj)
{
    bool success = obj.value("success").toBool();
    QString message = obj.value("message").toString();
    emit emitMappingCommandInfo(success, message);
}

void MappingManager::parseMappingProgress(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();

    if (status == 2) {
        QVariantList pose_obj = obj.value("trajectory").toArray().toVariantList();
        emit emitTrajectory(pose_obj);
    } else if(status == 4) {
        int progress = obj.value("progress").toInt();
        QString message = obj.value("message").toString();
        emit emitmappingProgressInfo(status, message, progress);
    }

}

void MappingManager::parseTransferDataRst(const QJsonObject &obj)
{
    bool success = obj.value("flag").toBool();
    QString message = obj.value("message").toString();
    emit emitTransferDataInfo(success, message);
}
