#include "QmlPresenter.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;
  const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                   &app, [url](QObject *obj, const QUrl &objUrl) {
    if (!obj && url == objUrl)
      QCoreApplication::exit(-1);
  }, Qt::QueuedConnection);
  
  qmlRegisterUncreatableType<CrossroadSide>("abc", 1, 0, "CrossroadSideModel", "");

  QmlPresenter qmlPresenter;
  engine.rootContext()->setContextProperty("engine", &qmlPresenter);
  
  engine.load(url);

  return app.exec();
}
