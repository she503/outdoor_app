#ifndef USERACCOUNTMANAGE_H
#define USERACCOUNTMANAGE_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QMap>
#include <QByteArray>
#include <QDebug>
#include "file_io.h"

class UserAccountManage : public QObject
{
    Q_OBJECT
public:
    explicit UserAccountManage(QObject *parent = nullptr);

    Q_INVOKABLE bool addNewOrUpdateUserAccount(const QString& key, const QString& value, const QString &level);

    Q_INVOKABLE bool getAllUserAccountData();

signals:
    void emitALLUserAccount(const QJsonObject& nomal, const QJsonObject& admin);
private:
    bool readAllUserAccountData();
private:
    FileIO *_file;
    QString _path;
    QJsonObject _all_obj;
    QJsonObject _nomal_obj;
    QJsonObject _admin_obj;

};

#endif // USERACCOUNTMANAGE_H
