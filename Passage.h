#pragma once
#include <QObject>
#include <QTextStream>
#include "Curve.h"

class Passage : public Curve
{
  Q_OBJECT
  Q_DISABLE_COPY(Passage)

  Q_PROPERTY(int InSideIndex MEMBER inSideIndex NOTIFY parametersChanged)
  Q_PROPERTY(int InLaneIndex MEMBER inLaneIndex NOTIFY parametersChanged)
  Q_PROPERTY(int OutSideIndex MEMBER outSideIndex NOTIFY parametersChanged)
  Q_PROPERTY(int OutLaneIndex MEMBER outLaneIndex NOTIFY parametersChanged)

  Q_PROPERTY(bool IsHighlighted MEMBER isHighlighted NOTIFY isHighlightedChanged)

  bool isHighlighted = false;

public:
  Passage(QObject* parent = nullptr);
  Passage(const QList<std::shared_ptr<CurvePoint>>& _curve,
          int inSideIndex, int inLaneIndex, int outSideIndex, int outLaneIndex,
          QObject* parent = nullptr);

  int inSideIndex = -1;
  int inLaneIndex = -1;
  int outSideIndex = -1;
  int outLaneIndex = -1;

  bool IsHighlighted() const;
  void SetHighlighted(bool value);

  void SetInLane(int sideIndex, int laneIndex);
  void SetOutLane(int sideIndex, int laneIndex);
  Q_INVOKABLE void Clear() override;

  void Serialize(QTextStream& stream) const;

  Q_INVOKABLE bool AppendNewPoint(QPoint point);
  Q_INVOKABLE bool AppendExistingPoint(int side, int lane, QPoint position);
  Q_INVOKABLE bool RemoveLastPoint() override;

signals:
  void parametersChanged();
  void isHighlightedChanged();

  void trajectoryReset();
  void pointAppended();
};
Q_DECLARE_METATYPE(Passage*)
