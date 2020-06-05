#ifndef TERGEO_APP_STATUS_MANAGER_H
#define TERGEO_APP_STATUS_MANAGER_H

#include <QObject>

enum WorkStatus {
    WORK_STATUS_NULL = 0,
    WORK_STATUS_NONE_WORK = 1,
    WORK_STATUS_SELECTING_MAP = 2,
    WORK_STATUS_LOCATION_CHOOSE_POINT = 3,
    WORK_STATUS_LOCATION_COMFIRM = 4,
    WORK_STATUS_SELECTING_TASK = 5,
    WORK_STATUS_WORKING = 6,
    WORK_STATUS_WORK_DONE = 7,
    WORK_STATUS_WORK_ERROR = 8
};

class StatusManager : public QObject
{
    Q_OBJECT
public:
    StatusManager(QObject *parent = nullptr);

    void setWorkStatus(const WorkStatus work_status);

    Q_INVOKABLE int getWorkStatus();

    Q_INVOKABLE int getNoneWorkID() { return (int)WORK_STATUS_NONE_WORK; }

    Q_INVOKABLE int getSelectMapID() {return (int)WORK_STATUS_SELECTING_MAP; }

    Q_INVOKABLE int getLocationChoosePointID() { return (int)WORK_STATUS_LOCATION_CHOOSE_POINT;}

    Q_INVOKABLE int getLocationComfirmID() { return (int)WORK_STATUS_LOCATION_COMFIRM; }

    Q_INVOKABLE int getSelectTaskID() { return (int)WORK_STATUS_SELECTING_TASK;}

    Q_INVOKABLE int getWorkingID() { return (int)WORK_STATUS_WORKING; }

    Q_INVOKABLE int getWorkDoneID() { return (int)WORK_STATUS_WORK_DONE; }

signals:
    void workStatusUpdate(const int status);

private:
    WorkStatus _current_status = WORK_STATUS_NULL;
};

#endif // STATUS_MANAGER_H
