#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QDebug>
#include <QTranslator>
#include <QtWebEngine>

#include "socket_manager.h"
#include "account_manager.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QtWebEngine::initialize();
//    QTranslator trans;
//    if (!trans.load(":/language/translation_chinese.qm")) {
//        qDebug() << "faild to load translation qm !!!";
//    }
//    app.installTranslator(&trans);
    QQmlApplicationEngine engine;

    AccountManager* account_manager = new AccountManager(&engine);
    engine.rootContext()->setContextProperty("account_manager", account_manager);

    SocketManager* socket_manager = new SocketManager(&engine);
    engine.rootContext()->setContextProperty("socket_manager", socket_manager);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
