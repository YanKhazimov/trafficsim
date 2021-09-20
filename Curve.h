#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QTextStream>
#include <memory>

class CurvePoint : public QObject
{
  Q_OBJECT

  QPoint pos;
  qreal angle = 0.0;
  qreal distanceTo = 0.0;

public:
  explicit CurvePoint(int x, int y, qreal distanceTo = 0.0, qreal angle = 0.0, QObject *parent = nullptr);

  QPoint GetPosition() const;
  qreal GetAngle() const;
  void SetAngle(qreal counterClockwiseValue);
  qreal GetDistanceTo() const;
  void SetDistanceTo(qreal distance);

  void Serialize(QTextStream& stream) const;
};

class Curve : public QAbstractListModel
{
  Q_OBJECT
  Q_DISABLE_COPY(Curve)

  QList<std::shared_ptr<CurvePoint>> points;

public:
  explicit Curve(QObject *parent = nullptr);
  Curve(const QList<std::shared_ptr<CurvePoint>>& points, QObject *parent = nullptr);

  // QAbstractListModel
  Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
  Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  QHash<int, QByteArray> roleNames() const;

  const QList<std::shared_ptr<CurvePoint>>& getPoints();
  virtual void Clear();

  Q_INVOKABLE void SetAngle(int row, qreal angle);
  Q_INVOKABLE QPoint GetPoint(int row) const;
  Q_INVOKABLE qreal GetDistanceTo(int row) const;

protected:
  void AddPoint(int x, int y);
  virtual bool RemoveLastPoint();
};
