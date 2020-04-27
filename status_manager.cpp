#include "status_manager.h"

StatusManager::StatusManager(QObject *parent) : QObject(parent)
{

}

void StatusManager::setWorkStatus(const int status)
{
    if (status != int(_current_status)) {
        _current_status = WorkStatus(status);
        emit workStatusUpdate(status);
    }
}

int StatusManager::getWorkStatus()
{
    return int(_current_status);
}
