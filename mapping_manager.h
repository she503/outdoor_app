#ifndef MAPPING_MANAGER_H
#define MAPPING_MANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QJsonDocument>

#include "utils.h"

enum MappingCommand {
    MAPPING_COMMAND_NULL = 0,
    MAPPING_COMMAND_START = 1,
    MAPPING_COMMAND_RESET = 2,
    MAPPING_COMMAND_STOP = 3,
    MAPPING_COMMAND_MAPPING = 4
};

enum MappingPlace {
    MAPPING_PLACE_NULL = 0,
    MAPPING_PLACE_INDOOR = 1,
    MAPPING_PLACE_OUTDOOR = 2
};

class MappingManager : public QObject
{
    Q_OBJECT
public:
    explicit MappingManager(QObject *parent = nullptr);

    Q_INVOKABLE void setIndoorOutdoor(const int indoor_outdoor, const QString &map_name);

    Q_INVOKABLE void setMappingCommand(const int mapping_command);

    Q_INVOKABLE void transferMappingData(const int key, const QString &map_name); // 1:to_usb  2:to_computer

    Q_INVOKABLE void recordMappingBag(const int status);

signals:
     void emitMappingCommandInfo(const bool success, const QString& message);
     void emitmappingProgressInfo(const int status, const QString& message,const int progress);
     void emitMappingFinish();
     void emitTrajectory(const QVariantList& trajectory);
     void emitTransferDataInfo(const bool flag, const QString& message);

     void emitSendSocketMessage(const QByteArray& message, bool compress);


private slots:
     void parseMappingCommandRst(const QJsonObject& obj);
     void parseMappingProgress(const QJsonObject& obj);
     void parseTransferDataRst(const QJsonObject& obj);

private:
    MappingCommand _mapping_command;
    MappingPlace _indoor_outdoor;
};

#endif // MAPPING_MANAGER_H
