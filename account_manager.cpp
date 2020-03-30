#include "account_manager.h"

#include <QCoreApplication>
#include <QDebug>

AccountManager::AccountManager(QObject *parent) : QObject(parent)
{

}

AccountManager::~AccountManager()
{

}

void AccountManager::setSocket(SocketManager *socket)
{
    _socket = socket;
    connect(_socket, SIGNAL(checkoutLogin(QJsonObject)), this, SLOT(checkoutLogin(QJsonObject)));
    connect(_socket, SIGNAL(addUser(QJsonObject)), this, SLOT(parseAddStatus(QJsonObject)));
    connect(_socket, SIGNAL(deleteUser(QJsonObject)), this, SLOT(parseDeleteStatus(QJsonObject)));
    connect(_socket, SIGNAL(updateUser(QJsonObject)), this, SLOT(parseUpdateStatus(QJsonObject)));
    connect(_socket, SIGNAL(allUser(QJsonObject)), this, SLOT(parseAllAccountsInfo(QJsonObject)));

}

void AccountManager::accountAdd(const QString &username, const QString &password, const int &level)
{
    QJsonObject obj;
    obj.insert("message_type", int(MessageType::MESSAGE_ADD_ACCOUNT));
    obj.insert("name", username);
    obj.insert("password", password);
    obj.insert("permission_level", level);
    QJsonDocument doc(obj);
    _socket->sendSocketMessage(doc.toJson());
}

void AccountManager::accountUpdate(const QString &username, const QString &password, const int &level)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_UPDATE_ACCOUNT));
    obj.insert("name", username);
    obj.insert("password", password);
    obj.insert("permission_level", level);
    QJsonDocument doc(obj);
    _socket->sendSocketMessage(doc.toJson());
}

void AccountManager::accountDelete(const QString &username)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_DELETE_ACCOUNT));
    obj.insert("name", username);
    QJsonDocument doc(obj);
    _socket->sendSocketMessage(doc.toJson());
}

void AccountManager::accountLogin(const QString &username, const QString &password)
{
    QJsonObject obj;
    obj.insert("message_type", int(MessageType::MESSAGE_LOGIN));
    obj.insert("name", username);
    obj.insert("password", password);
    QJsonDocument doc(obj);
    _socket->sendSocketMessage(doc.toJson());
}

void AccountManager::getAllAccounts()
{
    if (!_all_accounts_obj.empty()) {
        emit emitAllAccountInfo(_all_accounts_obj);
    }
}

void AccountManager::checkoutLogin(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitCheckOutLogin(status, message);
}

void AccountManager::parseAddStatus(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitAddAccountCB(status, message);
}

void AccountManager::parseDeleteStatus(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitDeleteAccountCB(status, message);
}

void AccountManager::parseUpdateStatus(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitUpdateAccountCB(status, message);
}

void AccountManager::parseAllAccountsInfo(const QJsonObject &obj)
{
    QJsonObject accounts_info = obj.value("accounts_info").toObject();

    QJsonObject account_username_level;
    QJsonObject::const_iterator it = accounts_info.begin();
    while (it != accounts_info.end()) {
        QString username = it.key();
        QJsonObject temp = it.value().toObject();
        int permission_level = temp.value("permission_level").toInt();
        account_username_level.insert(username, permission_level);
        ++it;
    }
    _all_accounts_obj = account_username_level;
    emit emitAllAccountInfo(account_username_level);
}


