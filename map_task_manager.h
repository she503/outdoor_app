#ifndef TERGEO_APP_MAP_TASK_MANAGER_H
#define TERGEO_APP_MAP_TASK_MANAGER_H

#include <QObject>

#include "utils.h"
#include "status_manager.h"
#include "socket_manager.h"

class MapTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit MapTaskManager(QObject *parent = nullptr);

    void setSocketManager(SocketManager* socket_manager);
    void setStatusManager(StatusManager* status_manager);

private:
    StatusManager* _status_manager;
    SocketManager* _socket_manager;
};

#endif // MAPTASKMANAGER_H
