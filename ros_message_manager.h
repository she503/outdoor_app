#ifndef ROSMESSAGEMANAGER_H
#define ROSMESSAGEMANAGER_H

#include <QObject>

class RosMessageManager : public QObject
{
    Q_OBJECT
public:
    explicit RosMessageManager(QObject *parent = nullptr);

signals:

public slots:
};

#endif // ROSMESSAGEMANAGER_H