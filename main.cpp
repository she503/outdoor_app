#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QDebug>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
//    QGuiApplication app(argc, argv);

    QApplication app(argc, argv);
//    QTranslator trans;
//    if (!trans.load(":/language/translation_chinese.qm")) {
//        qDebug() << "faild to load translation qm !!!";
//    }
//    app.installTranslator(&trans);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
