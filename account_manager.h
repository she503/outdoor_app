#ifndef ACCOUNT_MANAGER_H
#define ACCOUNT_MANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QMap>
#include "socket_manager.h"
#include "utils.h"

class AccountManager : public QObject
{
    Q_OBJECT
public:
    explicit AccountManager(QObject* parent = nullptr);
    ~AccountManager();

    void setSocket(SocketManager *socket);

    /**
     * @brief 添加用户
     */
    Q_INVOKABLE void accountAdd(const QString& username, const QString& password, const int& level);


    /**
     * @brief 更新用户
     */
    Q_INVOKABLE void accountUpdate(const QString& username, const QString& password,
                                   const int& level, QString old_pwd = "", bool need_old_pwd = false);


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
    Q_INVOKABLE void getAllAccounts();


    Q_INVOKABLE void getCurrentUserLevel();

signals:
    void emitCheckOutLogin(const int& status, const QString& message);
    void emitAllAccountInfo(const QJsonObject& accounts_info);
    void emitAddAccountCB(const int& status, const QString& message);
    void emitDeleteAccountCB(const int& status, const QString& message);
    void emitUpdateAccountCB(const int& status, const QString& message);
    void emitNameAndLevel(const QString& user_name, const int& level);


private slots:
    void checkoutLogin(const QJsonObject& obj);
    void parseAddStatus(const QJsonObject& obj);
    void parseDeleteStatus(const QJsonObject& obj);
    void parseUpdateStatus(const QJsonObject& obj);
    void parseAllAccountsInfo(const QJsonObject& obj);


private:

    SocketManager* _socket;
    QJsonObject _all_accounts_obj;
    QMap<QString, QPair<QString, PermissionLevel>> _accounts_map;
    QString _username;
    QString _password;
    int _level;
};

#endif // ACCOUNT_MANAGER_H
