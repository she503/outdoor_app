#include "account_manager.h"

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QDataStream>
#include <QDebug>

AccountManager::AccountManager(QObject *parent) : QObject(parent)
{
    this->readAccountsInfo();
    _current_user_name = "";
}

AccountManager::~AccountManager()
{
    this->writeAccountsInfo();
}

int AccountManager::addUser(const QString &user_name, const QString &pass_word, const int level)
{
    if (_account_info_map.contains(user_name)) {
        return 0;
    }
    if (!this->isLegalUserName(user_name)) {
        return 2;
    }
    if (!this->isLegalPassWord(pass_word)) {
        return 3;
    }
    if (!this->isLegalLevel(level)) {
        return 4;
    }

    QPair<QString, PermissionLevel> account_info(
                pass_word,PermissionLevel(level));
    _account_info_map[user_name] = account_info;
    return 1;
}

int AccountManager::updateUser(const QString &user_name, const QString &pass_word, const int level)
{
    if (!_account_info_map.contains(user_name)) {
        return 0;
    }
    if (!this->isLegalPassWord(pass_word)) {
        return 2;
    }
    if (!this->isLegalLevel(level)) {
        return 3;
    }

    QPair<QString, PermissionLevel> account_info(
                pass_word,PermissionLevel(level));
    _account_info_map[user_name] = account_info;

    return 1;
}

int AccountManager::deleteUser(const QString &user_name)
{
    if (!_account_info_map.contains(user_name)) {
        return 0;
    }

    QMap<QString, QPair<QString, PermissionLevel> >::iterator iter =
            _account_info_map.find(user_name);
    _account_info_map.erase(iter);
    return 1;
}

int AccountManager::checkLogin(const QString &user_name, const QString &pass_word)
{
    if (!_account_info_map.contains(user_name)) {
        return 0;
    }
    QMap<QString, QPair<QString, PermissionLevel> >::const_iterator
            iter = _account_info_map.find(user_name);
    if (iter.value().first != pass_word) {
        return 1;
    }
    _current_user_name = user_name;
    return 2;
}

int AccountManager::getCurrentAccountLevel() const
{
    QMap<QString, QPair<QString, PermissionLevel> >::const_iterator
            iter = _account_info_map.find(_current_user_name);
    if (iter == _account_info_map.constEnd()) {
        return int(PermissionLevel::UNKNOWN);
    }
    return int(iter.value().second);
}

bool AccountManager::getAllAcountInfo() //const
{
    if (_account_info_map.isEmpty()) {
        return false;
    }
    QJsonObject obj;
    QMap<QString, QPair<QString, PermissionLevel> >::const_iterator
            iter = _account_info_map.constBegin();
    while (iter != _account_info_map.constEnd()) {
        obj.insert(iter.key(), int(iter.value().second));
        ++iter;
    }
    emit emitAllAccountInfo(obj);
    return true;
}

void AccountManager::readAccountsInfo()
{
    QString account_file_path;
    QString account_file_dir;
#if defined(Q_OS_ANDROID)
    account_file_path = "/data/data/tonglu.tergeo_app/accounts/accounts.tl";
    account_file_dir = "/data/data/tonglu.tergeo_app/accounts/";
#else
    QString current_path = QCoreApplication::applicationDirPath();
    account_file_dir = current_path + "/res";
    account_file_path = current_path + "/res/accounts.tl";
#endif
    QDir account_dir(account_file_dir);
    if (!account_dir.exists()) {
        account_dir.mkpath(account_file_dir);
    }
    if (!this->readAccountsFromFile(account_file_path)) {
        QPair<QString, PermissionLevel> account_info("password", PermissionLevel::ADMIN);
        _account_info_map["admin"] = account_info;
    }
}

void AccountManager::writeAccountsInfo()
{
    QString account_file_path;
#if defined(Q_OS_ANDROID)
    account_file_path = "/data/data/tonglu.tergeo_app/accounts/accounts.tl";
#else
    QString current_path = QCoreApplication::applicationDirPath();
    account_file_path = current_path + "/res/accounts.tl";
#endif
    QFile out_file(account_file_path);
    if (!out_file.open(QIODevice::WriteOnly)) {
        return;
    }
    QDataStream out_stream(&out_file);
    out_stream << _account_info_map.size();
    QMap<QString, QPair<QString, PermissionLevel> >::const_iterator
            iter = _account_info_map.constBegin();
    while (iter != _account_info_map.constEnd()) {
        out_stream << iter.key() << iter.value().first << int(iter.value().second);
        ++iter;
    }
}

bool AccountManager::readAccountsFromFile(const QString &file)
{
    QFile account_file(file);
    if (!account_file.exists()) {
        return false;
    }

    if (!account_file.open(QIODevice::ReadOnly)) {
        return false;
    }

    QDataStream in_file(&account_file);
    int account_num = 0;
    in_file >> account_num;

    if (account_num <= 0) {
        return false;
    }
    for (int i = 0; i < account_num; ++i) {
        QString user_name = "";
        QString pass_word = "";
        int level = 0;
        in_file >> user_name >> pass_word >> level;
        if (level < 0 || level > 2) {
            level = 0;
        }
        QPair<QString, PermissionLevel> account_info(pass_word, PermissionLevel(level));
        _account_info_map[user_name] = account_info;
    }
    return true;
}

bool AccountManager::isLegalUserName(const QString &user_name)
{
    // TODO: 判断用户名是否符合要求
    return true;
}

bool AccountManager::isLegalPassWord(const QString &pass_word)
{
    // TODO: 判断密码是否符合要求
    return true;
}

bool AccountManager::isLegalLevel(const int level)
{
    if (level >= 1 && level <= 2) {
        return true;
    }
    return false;
}


