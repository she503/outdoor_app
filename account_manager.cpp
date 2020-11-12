#include "account_manager.h"
#include <QDebug>
#include <QCoreApplication>

AccountManager::AccountManager(QObject *parent) : QObject(parent)
{

}

AccountManager::~AccountManager()
{

}

void AccountManager::accountAdd(const QString &username,
                                const QString &password, const int &level)
{
    QJsonObject obj;
    obj.insert("message_type", int(MessageType::MESSAGE_ADD_ACCOUNT));
    obj.insert("name", username);
    obj.insert("password", password);
    obj.insert("permission_level", level);
    QJsonDocument doc(obj);
    emit emitSendSocketMessage(doc.toJson(), false);
}

void AccountManager::accountUpdate(const QString &username, const QString &password,
                                   const int &level, QString old_pwd, bool need_old_pwd)
{
    if (need_old_pwd ) {
        QString real_old_pwd = _accounts_map.value(username).first;
        if (real_old_pwd != old_pwd) {
            QJsonObject temp_obj;
            temp_obj.insert("status", 0);
            temp_obj.insert("message", "error old pwd");
//            parseUpdateStatus(temp_obj);
            return;
        }
    }
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_UPDATE_ACCOUNT));
    obj.insert("name", username);
    obj.insert("password", password);
    obj.insert("permission_level", level);
    QJsonDocument doc(obj);
    emit emitSendSocketMessage(doc.toJson(), false);
}

void AccountManager::accountDelete(const QString &username)
{
    QJsonObject obj;
    obj.insert("message_type", int(MESSAGE_DELETE_ACCOUNT));
    obj.insert("name", username);
    QJsonDocument doc(obj);
    emit emitSendSocketMessage(doc.toJson(), false);
}

void AccountManager::accountLogin(const QString &username, const QString &password)
{
    QJsonObject obj;
    obj.insert("message_type", int(MessageType::MESSAGE_LOGIN));
    obj.insert("name", username);
    obj.insert("password", password);
    QJsonDocument doc(obj);
    emit emitSendSocketMessage(doc.toJson(), false);
    _current_username = username;
    _current_password = password;
}

QJsonObject AccountManager::getAllAccountsInfo()
{
    QJsonObject all_accounts_info_obj;
    QMap<QString, QPair<QString, PermissionLevel> >::const_iterator iter =
            _accounts_map.constBegin();
    for (; iter != _accounts_map.constEnd(); ++iter) {
        all_accounts_info_obj.insert(iter.key(), int(iter.value().second));
    }
    return all_accounts_info_obj;
}


void AccountManager::parseLoginRst(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    int level = obj.value("level").toInt();

    if (status == 1) {
        _current_level = level;
    } else if (status == 0) {
        _current_username = "";
        _current_password = "";
    }
    emit emitLoginRst(status, message);
}

void AccountManager::parseAddRst(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitAddAccountRst(status, message);
}

void AccountManager::parseDeleteRst(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitDeleteAccountRst(status, message);
}

void AccountManager::parseUpdateRst(const QJsonObject &obj)
{
    int status = obj.value("status").toInt();
    QString message = obj.value("message").toString();
    emit emitUpdateAccountRst(status, message);
}

void AccountManager::parseAllAccountsInfo(const QJsonObject &obj)
{
    _accounts_map.clear();
    QJsonObject accounts_info = obj.value("accounts_info").toObject();

    QJsonObject account_username_level;
    QJsonObject::const_iterator it = accounts_info.begin();
    while (it != accounts_info.end()) {
        QString username = it.key();
        QJsonObject temp = it.value().toObject();
        int permission_level = temp.value("permission_level").toInt();
        QString password = temp.value("password").toString();
        account_username_level.insert(username, permission_level);
        QPair<QString, PermissionLevel> level_pwd(
                    password, (PermissionLevel)permission_level);
        _accounts_map.insert(username, level_pwd);
        ++it;
    }
    _all_accounts_obj = account_username_level;
    emit emitAllAccountInfo(account_username_level);
}
