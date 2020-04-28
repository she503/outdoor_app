#include "status_manager.h"
#include <QDebug>
StatusManager::StatusManager(QObject *parent) : QObject(parent), _current_status(WORK_STATUS_NULL)
{

}

void StatusManager::setWorkStatus(const WorkStatus work_status)
{
    if (work_status != _current_status) {
        _current_status = work_status;

        emit workStatusUpdate(work_status);
    }
}

int StatusManager::getWorkStatus()
{
    return int(_current_status);
}
