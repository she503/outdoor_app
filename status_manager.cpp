#include "status_manager.h"

StatusManager::StatusManager(QObject *parent) : QObject(parent)
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
