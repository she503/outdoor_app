#include "account_manager.h"

#include <QCoreApplication>
#include <fstream>
#include <QDir>
#include <QDebug>

AccountManager::AccountManager(QObject *parent) : QObject(parent)
{
    this->readFromProto();
    _current_user_name = "";
}

AccountManager::~AccountManager()
{
    this->writeToProto();
}

int AccountManager::addUser(const QString &user_name, const QString &pass_word, const int level)
{
    std::string user_name_std = user_name.toStdString();
    std::string pass_word_std = pass_word.toStdString();

    if (_account_info_map.contains(user_name_std)) {
        return 0;
    }
    if (!this->isLegalUserName(user_name_std)) {
        return 2;
    }
    if (!this->isLegalPassWord(pass_word_std)) {
        return 3;
    }
    if (!this->isLegalLevel(level)) {
        return 4;
    }

    QPair<std::string, proto::PermissionLevel> account_info(
                pass_word_std,proto::PermissionLevel(level));
    _account_info_map[user_name_std] = account_info;
    return 1;
}

int AccountManager::updateUser(const QString &user_name, const QString &pass_word, const int level)
{
    std::string user_name_std = user_name.toStdString();
    std::string pass_word_std = pass_word.toStdString();

    if (!_account_info_map.contains(user_name_std)) {
        return 0;
    }
    if (!this->isLegalPassWord(pass_word_std)) {
        return 2;
    }
    if (!this->isLegalLevel(level)) {
        return 3;
    }

    QPair<std::string, proto::PermissionLevel> account_info(
                pass_word_std,proto::PermissionLevel(level));
    _account_info_map[user_name_std] = account_info;

    return 1;
}

int AccountManager::deleteUser(const QString &user_name)
{
    std::string user_name_std = user_name.toStdString();

    if (!_account_info_map.contains(user_name_std)) {
        return 0;
    }

    QMap<std::string, QPair<std::string, proto::PermissionLevel> >::iterator iter =
            _account_info_map.find(user_name_std);
    _account_info_map.erase(iter);
    return 1;
}

int AccountManager::checkLogin(const QString &user_name, const QString &pass_word)
{
    std::string user_name_std = user_name.toStdString();
    std::string pass_word_std = pass_word.toStdString();
    if (!_account_info_map.contains(user_name_std)) {
        return 0;
    }
    QMap<std::string, QPair<std::string, proto::PermissionLevel> >::const_iterator
            iter = _account_info_map.find(user_name_std);
    if (iter.value().first != pass_word_std) {
        return 1;
    }
    _current_user_name = user_name_std;
    return 2;
}

int AccountManager::getCurrentAccountLevel() const
{
    QMap<std::string, QPair<std::string, proto::PermissionLevel> >::const_iterator
            iter = _account_info_map.find(_current_user_name);
    if (iter == _account_info_map.constEnd()) {
        return int(proto::PermissionLevel::UNKNOWN);
    }
    return int(iter.value().second);
}

bool AccountManager::getAllAcountInfo() //const
{
    if (_account_info_map.isEmpty()) {
        return false;
    }
//    QMap<QString, int> accounts_info;
    QJsonObject obj;
    QMap<std::string, QPair<std::string, proto::PermissionLevel> >::const_iterator
            iter = _account_info_map.constBegin();
    while (iter != _account_info_map.constEnd()) {
//        accounts_info[QString::fromStdString(iter.key())] = int(iter.value().second);
        obj.insert(QString::fromStdString(iter.key()), int(iter.value().second));
        ++iter;
    }
    emit emitAllAccountInfo(obj);
    return true;
}

void AccountManager::protoToAccountMap()
{
    int account_size = _proto_account_info.account_size();
    for (int i = 0; i < account_size; ++i) {
        QPair<std::string, proto::PermissionLevel> account_info(
                    _proto_account_info.account(i).password(),
                    _proto_account_info.account(i).level());
        _account_info_map[_proto_account_info.account(i).user_name()] = account_info;
    }
}

void AccountManager::accountMapToProto()
{
    _proto_account_info.clear_account();

    QMap<std::string, QPair<std::string, proto::PermissionLevel> >::const_iterator
            iter = _account_info_map.constBegin();
    while (iter != _account_info_map.constEnd()) {
        proto::Account* account = _proto_account_info.add_account();
        account->set_user_name(iter.key());
        account->set_password(iter.value().first);
        account->set_level(iter.value().second);
        ++iter;
    }
}

void AccountManager::readFromProto()
{
    _proto_account_info.clear_account();

    QString current_path = QCoreApplication::applicationDirPath();
    QString account_file_dir = current_path + "/res/Account";
    QDir account_dir(account_file_dir);
    if (!account_dir.exists()) {
        account_dir.mkpath(account_file_dir);
    }
    QString account_file_path = current_path + "/res/Account/accounts.tl";
    QFile account_file(account_file_path);
    if (!account_file.exists()) {
        proto::Account* account = _proto_account_info.add_account();
        account->set_level(proto::PermissionLevel::ADMIN);
        account->set_user_name("admin");
        account->set_password("password");
        this->protoToAccountMap();
        this->writeToProto();
        return;
    }

    std::fstream in_file(account_file_path.toStdString(), std::ios::in | std::ios::binary);
    if (!in_file.good() || !_proto_account_info.ParseFromIstream(&in_file) ||
                            _proto_account_info.account_size() == 0) {
        // ADD THE DEFAULT ACCOUNT INFO
        proto::Account* account = _proto_account_info.add_account();
        account->set_level(proto::PermissionLevel::ADMIN);
        account->set_user_name("admin");
        account->set_password("password");
    }
    this->protoToAccountMap();
    return;
}

void AccountManager::writeToProto()
{
    this->accountMapToProto();
    QString current_path = QCoreApplication::applicationDirPath();
    QString account_file_path = current_path + "/res/Account/accounts.tl";
    std::fstream out_file(account_file_path.toStdString(),
            std::ios::out | std::ios::trunc | std::ios::binary);
    _proto_account_info.SerializeToOstream(&out_file);
}

bool AccountManager::isLegalUserName(const std::string &user_name)
{
    // TODO: 判断用户名是否符合要求
    return true;
}

bool AccountManager::isLegalPassWord(const std::string &pass_word)
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
