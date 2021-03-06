#ifndef TERGEO_APP_ACCOUNT_MANAGER_H
#define TERGEO_APP_ACCOUNT_MANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QMap>
#include <QPair>
#include "utils.h"

class AccountManager : public QObject
{
    Q_OBJECT
public:
    explicit AccountManager(QObject* parent = nullptr);
    ~AccountManager();

    /**
     * @brief 添加用户
     */
    Q_INVOKABLE void accountAdd(const QString& username,
                                const QString& password, const int& level);

    /**
     * @brief 更新用户
     */
    Q_INVOKABLE void accountUpdate(const QString& username, const QString& password,
                                   const int& level, QString old_pwd = "",
                                   bool need_old_pwd = false);

    /**
     * @brief 删除用户
     */
    Q_INVOKABLE void accountDelete(const QString& username);


    /**
     * @brief 用户登录
     */
    Q_INVOKABLE void accountLogin(const QString& username, const QString& password);


    /**
     * @brief 获取用户信息
     */
    Q_INVOKABLE QJsonObject getAllAccountsInfo();


    Q_INVOKABLE int getCurrentUserLevel() { return _current_level;}

    Q_INVOKABLE QString getCurrentUserName() { return _current_username;}

    Q_INVOKABLE QString getCurrentUserPwd() { return _current_password;}

    Q_INVOKABLE bool checkoutPwd(const QString& pwd) { return pwd.compare(_current_password) == 0; }

signals:
    void emitLoginRst(const int& status, const QString& message);
    void emitAddAccountRst(const int& status, const QString& message);
    void emitDeleteAccountRst(const int& status, const QString& message);
    void emitUpdateAccountRst(const int& status, const QString& message);
    void emitAllAccountInfo(const QJsonObject& accounts_info);

    void emitSendSocketMessage(const QByteArray& message, bool compress);

private slots:
    void parseLoginRst(const QJsonObject& obj);
    void parseAddRst(const QJsonObject& obj);
    void parseDeleteRst(const QJsonObject& obj);
    void parseUpdateRst(const QJsonObject& obj);
    void parseAllAccountsInfo(const QJsonObject& obj);

private:
    QJsonObject _all_accounts_obj;
    QMap<QString, QPair<QString, PermissionLevel> > _accounts_map;

    QString _current_username;
    QString _current_password;
    int _current_level;
};

#endif // ACCOUNT_MANAGER_H
