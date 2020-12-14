#include "RegularCrossroad.h"

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
  
  RegularCrossroad crossroad;
  CrossroadSide side1(2, 3, 10, 10, 40);
  CrossroadSide side2(3, 1, 10, 10, 40);
  crossroad.AddSide(90, &side1);
  crossroad.AddSide(315, &side2);
  engine.rootContext()->setContextProperty("crossroad", &crossroad);
  
  engine.load(url);

  return app.exec();
}
