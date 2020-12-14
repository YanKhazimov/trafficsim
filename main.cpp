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
  
  qmlRegisterUncreatableType<CrossroadSide>("abc", 1, 0, "CrossroadSideModel", "");

  RegularCrossroad crossroad;
  //CrossroadSide side1(90.0, 2, 3, 10, 10, 40);
  //CrossroadSide side2(315.0, 3, 1, 10, 10, 40);
  CrossroadSide side0(90.0, 2, 1, 100, 10, 10);
  CrossroadSide side1(0.0, 2, 2, 10, 10, 10);
  CrossroadSide side2(270.0, 1, 1, 100, 10, 10);
  CrossroadSide side3(180.0, 2, 2, 10, 10, 10);
  crossroad.AddSide(&side0);
  crossroad.AddSide(&side1);
  crossroad.AddSide(&side2);
  crossroad.AddSide(&side3);
  engine.rootContext()->setContextProperty("crossroad", &crossroad);
  
  engine.load(url);

  return app.exec();
}
