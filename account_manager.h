#ifndef ACCOUNT_MANAGER_H
#define ACCOUNT_MANAGER_H

#include <QObject>
#include <QMap>
#include <QPair>
#include <QJsonObject>
#include <QList>

class AccountManager : public QObject
{
    Q_OBJECT
public:
    explicit AccountManager(QObject* parent = nullptr);
    ~AccountManager();

    enum PermissionLevel {
        UNKNOWN = 0,
        NORMAL = 1,
        ADMIN = 2
    };

    /**
     * @brief 添加用户
     * @return 0: 已包含此用户   1: 添加成功
     *         2: 用户名格式错误 3: 密码格式错误  4: 权限级别错误
     */
    Q_INVOKABLE int addUser(const QString& user_name, const QString& pass_word, const int level);

    /**
     * @brief 更新用户
     * @return 0: 没有此用户    1: 更新成功
     *         2: 密码格式错误  3: 权限级别错误
     */
    Q_INVOKABLE int updateUser(const QString& user_name, const QString& pass_word, const int level);

    /**
     * @brief 删除用户
     * @return 0: 没有此用户    1: 删除成功
     */
    Q_INVOKABLE int deleteUser(const QString& user_name);

    /**
     * @brief 用户登录
     * @return 0: 没有此用户    1: 密码错误
     *         2: 登录成功
     */
    Q_INVOKABLE int checkLogin(const QString& user_name, const QString& pass_word);

    /**
     * @brief 获取当前用户权限等级
     * @return 0: 位置等级    1: 普通用户    2: 管理员用户
     */
    Q_INVOKABLE int getCurrentAccountLevel() const;

    /**
     * @brief 获取当前所有用户信息
     * @return false: 当前用户信息为空   true: 获取成功
     */
    Q_INVOKABLE bool getAllAcountInfo();// const;


signals:
    void emitAllAccountInfo(const QJsonObject& accounts_info);

private:
    void readAccountsInfo();
    void writeAccountsInfo();
    bool readAccountsFromFile(const QString& file);

    bool isLegalUserName(const QString& user_name);
    bool isLegalPassWord(const QString& pass_word);
    bool isLegalLevel(const int level);

private:
    QString _current_user_name;
    QMap<QString, QPair<QString, PermissionLevel> > _account_info_map;
};

#endif // ACCOUNT_MANAGER_H
