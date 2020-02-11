#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "user_account_manage.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    UserAccountManage* user_manage = new UserAccountManage(&engine);
    engine.rootContext()->setContextProperty("user_manage", user_manage);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
