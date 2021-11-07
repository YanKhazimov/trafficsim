#include "QmlPresenter.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QResource>
#include <QDebug>

int main(int argc, char *argv[])
{
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QGuiApplication app(argc, argv);

  if (!QResource::registerResource("D:/QtProjects/trafficsim/resources/meshes.rcc"))
      qWarning() << "Cannot load external resources";

  QQmlApplicationEngine engine;
  const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                   &app, [url](QObject *obj, const QUrl &objUrl) {
    if (!obj && url == objUrl)
      QCoreApplication::exit(-1);
  }, Qt::QueuedConnection);
  
  qmlRegisterUncreatableType<CrossroadSide>("TrafficSimApp", 1, 0, "CrossroadSideModel", "");
  qmlRegisterType<QmlPresenter>("TrafficSimApp", 1, 0, "EditorState");
  qmlRegisterUncreatableType<Car>("TrafficSimApp", 1, 0, "CarModel", "");
  qmlRegisterType<Node>("TrafficSimApp", 1, 0, "NodeType");
  qmlRegisterUncreatableType<Curve>("TrafficSimApp", 1, 0, "CurveModel", "");

  QmlPresenter qmlPresenter;

  engine.rootContext()->setContextProperty("engine", &qmlPresenter);

  engine.load(url);

  QObject *rootObject = engine.rootObjects().first();
  qmlPresenter.SetQmlRoot(rootObject);

  return app.exec();
}
