#ifndef MAPPING_MANAGER_H
#define MAPPING_MANAGER_H

#include <QObject>

#include "socket_manager.h"
enum MappingStatus {
    MAPPING_STATUS_NULL = 0,
    MAPPING_STATUS_START = 1,
    MAPPING_STATUS_STOP = 2
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

    Q_INVOKABLE void setMappingStartOrStop(const int mapping_status);

    Q_INVOKABLE void setIndoorOutdoor(const int indoor_outdoor) { _indoor_outdoor = (MappingPlace)indoor_outdoor;}

signals:

public slots:

private:
    SocketManager *_socket_manager;
    MappingStatus _mapping_status;
    MappingPlace _indoor_outdoor;
};

#endif // MAPPING_MANAGER_H
