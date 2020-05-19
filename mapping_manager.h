#ifndef MAPPING_MANAGER_H
#define MAPPING_MANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

#include "utils.h"
#include "socket_manager.h"
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
    bool setSocketManager(SocketManager* socket_manager);

    Q_INVOKABLE void setIndoorOutdoor(const int indoor_outdoor);

    Q_INVOKABLE void setMappingCommand(const int mapping_command);
signals:
     void emitMappingCommandInfo(const bool success, const QString& message);
     void emitmappingProgressInfo(const int status, const QString& message,const int progress);
     void emitMappingFinish();
private slots:
     void parseMappingCommandRst(const QJsonObject& obj);
     void parseMappingProgress(const QJsonObject& obj);
private:
    SocketManager* _socket_manager;
    MappingCommand _mapping_command;
    MappingPlace _indoor_outdoor;
};

#endif // MAPPING_MANAGER_H
