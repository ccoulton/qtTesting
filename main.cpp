#include <QDebug>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>

int main(int argc, char **argv) {
    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:main.qml"));
    if (engine.rootObjects().isEmpty()){
        return -1;
    }
    qDebug() << "Hello Worlds!";
    return application.exec();
}
