#pragma once
#include <QObject>

class Passage : public QObject
{
  Q_OBJECT
  Q_DISABLE_COPY(Passage)

  Q_PROPERTY(int InSideIndex MEMBER inSideIndex NOTIFY parametersChanged)
  Q_PROPERTY(int InLaneIndex MEMBER inLaneIndex NOTIFY parametersChanged)
  Q_PROPERTY(int OutSideIndex MEMBER outSideIndex NOTIFY parametersChanged)
  Q_PROPERTY(int OutLaneIndex MEMBER outLaneIndex NOTIFY parametersChanged)

  Q_PROPERTY(bool IsHighlighted MEMBER isHighlighted NOTIFY isHighlightedChanged)

public:
  Passage(QObject* parent = nullptr);
  Passage(int inSideIndex, int inLaneIndex, int outSideIndex, int outLaneIndex, QObject* parent = nullptr);

  int inSideIndex = -1;
  int inLaneIndex = -1;
  int outSideIndex = -1;
  int outLaneIndex = -1;

  bool isHighlighted = false;

  void SetInLane(int sideIndex, int laneIndex);
  void SetOutLane(int sideIndex, int laneIndex);
  void Reset();

signals:
  void parametersChanged();
  void isHighlightedChanged();
};
Q_DECLARE_METATYPE(Passage*)
