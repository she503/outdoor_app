#include "user_account_manage.h"

UserAccountManage::UserAccountManage(QObject *parent) : QObject(parent)
{
//    _path = "/home/qc/tongji/app/tergeo_app/res/Others/user.tl";
    _path = ":/UserAccount/res/Others/user.tl";
    readAllUserAccountData();
}

bool UserAccountManage::addNewOrUpdateUserAccount(const QString &key, const QString &value, const QString& level)
{
    if (level != "nomal_user" && level != "admin_user") {
        qCritical() << "[UserAccountManage::addNewOrUpdateUserAccount]: level error!!!";
        return false;
    }

    if (level == "nomal_user") {
        _nomal_obj.insert(key, value);
        _all_obj.insert("nomal_user", _nomal_obj);
    } else if (level == "admin_user") {
        _admin_obj.insert(key, value);
        _all_obj.insert("admin_user", _admin_obj);
    }

    if (_file->writeData(_all_obj)) {
        return true;
    } else {
        return false;
    }
}

bool UserAccountManage::readAllUserAccountData()
{
    _file = new FileIO(_path);
    QJsonDocument doc;
    doc = _file->readData();

    QJsonObject obj(doc.object());
    if (obj.contains("nomal_user")) {
        QJsonObject nomal_obj = obj.value("nomal_user").toObject();
        _nomal_obj = nomal_obj;

    }
    if (obj.contains("admin_user")) {
        QJsonObject admin_obj = obj.value("admin_user").toObject();
        _admin_obj = admin_obj;
    }
    _all_obj = obj;
    emit emitALLUserAccount(_nomal_obj, _admin_obj);

    return true;
}

bool UserAccountManage::getAllUserAccountData()
{
    if (!_nomal_obj.empty() || !_admin_obj.empty()) {
        emit emitALLUserAccount(_nomal_obj, _admin_obj);
        return true;
    } else {
        qCritical() << "[UserAccountManage::getAllUserAccountData]: dont init obj!";
        return false;
    }
}
