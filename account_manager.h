#ifndef ACCOUNT_MANAGER_H
#define ACCOUNT_MANAGER_H

#include <QObject>
#include <QJsonObject>
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
    Q_INVOKABLE void accountUpdate(const QString& username, const QString& password, const int& level);


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



signals:
    void emitCheckOutLogin(const int& status, const QString& message);
    void emitAllAccountInfo(const QJsonObject& accounts_info);
    void emitAddAccountCB(const int& status, const QString& message);
    void emitDeleteAccountCB(const int& status, const QString& message);
    void emitUpdateAccountCB(const int& status, const QString& message);


private slots:
    void checkoutLogin(const QJsonObject& obj);
    void parserAddStatus(const QJsonObject& obj);
    void parseDeleteStatus(const QJsonObject& obj);
    void parseUpdateStatus(const QJsonObject& obj);
    void parseAllAccountsInfo(const QJsonObject& obj);


private:

    SocketManager* _socket;
    QJsonObject _all_accounts_obj;
};

#endif // ACCOUNT_MANAGER_H
