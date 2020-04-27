#ifndef TERGEO_APP_STATUS_MANAGER_H
#define TERGEO_APP_STATUS_MANAGER_H

#include <QObject>

enum WorkStatus {
    WORK_STATUS_NULL = 0,
    WORK_STATUS_NONE_WORK = 1,
    WORK_STATUS_SELECTING_MAP = 2,
    WORK_STATUS_INIT_LOCATING = 3,
    WORK_STATUS_SELECTING_TASK = 4,
    WORK_STATUS_WORKING = 5,
    WORK_STATUS_WORK_DONE = 6,
    WORK_STATUS_WORK_ERROR = 7
};

class StatusManager : public QObject
{
    Q_OBJECT
public:
    StatusManager(QObject *parent = nullptr);

    void setWorkStatus(const WorkStatus work_status);
    Q_INVOKABLE int getWorkStatus();

signals:
    void workStatusUpdate(const int status);

private:
    WorkStatus _current_status = WORK_STATUS_NULL;
};

#endif // STATUS_MANAGER_H
