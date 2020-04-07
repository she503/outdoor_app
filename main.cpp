#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QDebug>
#include <QTranslator>
#include <QtWebView/QtWebView>
#include <QIcon>

#include "socket_manager.h"
#include "account_manager.h"
#include "map_task_manager.h"
#include "ros_message_manager.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    QIcon icon(":/res/pictures/logo_3.png");
    app.setWindowIcon(icon);
    app.setApplicationName("中振同辂洗地机");

    QtWebView::initialize();
    QTranslator trans;
    if (!trans.load(":/res/translate/tergeo_app_zh_CN.qm")) {
        qDebug() << "faild to load translation qm !!!";
    }
    app.installTranslator(&trans);
    QQmlApplicationEngine engine;

    SocketManager* socket_manager = new SocketManager(&engine);
    engine.rootContext()->setContextProperty("socket_manager", socket_manager);

    AccountManager* account_manager = new AccountManager(&engine);
    engine.rootContext()->setContextProperty("account_manager", account_manager);
    account_manager->setSocket(socket_manager);

    MapTaskManager* map_task_manager = new MapTaskManager(&engine);
    engine.rootContext()->setContextProperty("map_task_manager", map_task_manager);
    map_task_manager->setSocket(socket_manager);

    RosMessageManager* ros_message_manager = new RosMessageManager(&engine);
    engine.rootContext()->setContextProperty("ros_message_manager", ros_message_manager);
    ros_message_manager->setSocket(socket_manager);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
