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

void AccountManager::accountUpdate(const QString &username, const QString &password, const int &level,
                                   QString old_pwd, bool need_old_pwd)
{
    if (need_old_pwd ) {
        QString real_old_pwd = _accounts_map.value(username).first;
        if (real_old_pwd != old_pwd) {
            QJsonObject temp_obj;
            temp_obj.insert("status", 0);
            temp_obj.insert("message", "error old pwd");
            parseUpdateStatus(temp_obj);
            return;
        }
    }
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
    _username = username;
    _password = password;
}

void AccountManager::getAllAccounts()
{
    if (!_all_accounts_obj.empty()) {
        emit emitAllAccountInfo(_all_accounts_obj);
    }
}

void AccountManager::getCurrentUserLevel()
{
    emit emitNameAndLevel(_username, _level);
}

void AccountManager::checkoutLogin(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    int level = obj.value("level").toInt();
    emit emitCheckOutLogin(status, message);
    if (status == 1) {
        _level = level;
    } else if (status == 0) {
        _username = "";
        _password = "";
    }
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
        QString password = temp.value("password").toString();
        account_username_level.insert(username, permission_level);
        QPair<QString, PermissionLevel> level_pwd(password, (PermissionLevel)permission_level);
        _accounts_map.insert(username, level_pwd);
        ++it;
    }
    _all_accounts_obj = account_username_level;
    emit emitAllAccountInfo(account_username_level);
}


