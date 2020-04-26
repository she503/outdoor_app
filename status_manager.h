#ifndef TERGEO_APP_STATUS_MANAGER_H
#define TERGEO_APP_STATUS_MANAGER_H

#include <QObject>

enum WorkStatus {
    WORK_STATUS_NULL = 0,
    WORK_STATUS_MAP_SELECTED_NOT_LOCATING = 1,
    WORK_STATUS_MAP_SELECTED_INIT_LOCATING = 2,
    WORK_STATUS_MAP_SELECTED_LOCATING = 3,
    WORK_STATUS_WORKING = 4,
    WORK_STATUS_DONE = 5,
    WORK_STATUS_ERROR = 6
};

class StatusManager : public QObject
{
    Q_OBJECT
public:
    StatusManager(QObject *parent = nullptr);

    void setWorkStatus(const int status);
    int getWorkStatus();

signals:
    void workStatusUpdate(const int status);

private:
    WorkStatus _current_status = WORK_STATUS_NULL;
};

#endif // STATUS_MANAGER_H
