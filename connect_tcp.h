#ifndef CONNECTTCP_H
#define CONNECTTCP_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "status_manager.h"
#include "tcp_manager.h"
#include "account_manager.h"
#include "map_task_manager.h"
#include "ros_message_manager.h"
#include "vehicle_info_manager.h"
#include "mapping_manager.h"

class ConnectTcp : public QObject
{
    Q_OBJECT
public:
    explicit ConnectTcp(QObject *parent = nullptr);

    void setEngine(QQmlApplicationEngine &engine);
signals:

public slots:
};

#endif // CONNECTTCP_H
