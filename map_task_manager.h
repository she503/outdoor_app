#ifndef MAPTASKMANAGER_H
#define MAPTASKMANAGER_H

#include <QObject>

#include "utils.h"
#include "socket_manager.h"

class MapTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit MapTaskManager(QObject *parent = nullptr);

private:

signals:

public slots:
};

#endif // MAPTASKMANAGER_H
