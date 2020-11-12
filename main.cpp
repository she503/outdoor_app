#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QDebug>
#include <QTranslator>
#include <QtWebView/QtWebView>
#include <QIcon>

#include "connect_tcp.h"

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

    ConnectTcp* connect_tcp = new ConnectTcp();
    connect_tcp->setEngine(engine);


    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
