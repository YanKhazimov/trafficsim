#include "Passage.h"
#include "DataRoles.h"
#include <QDebug>

Passage::Passage(QObject* parent)
  : Curve(parent)
{
  inSideIndex = -1;
  inLaneIndex = -1;
  outSideIndex = -1;
  outLaneIndex = -1;
}

Passage::Passage(const QList<std::shared_ptr<CurvePoint>>& _curve,
                 int _inSideIndex, int _inLaneIndex, int _outSideIndex, int _outLaneIndex,
                 QObject* parent)
  : Curve(_curve, parent)
{
  inSideIndex = _inSideIndex;
  inLaneIndex = _inLaneIndex;
  outSideIndex = _outSideIndex;
  outLaneIndex = _outLaneIndex;
}

bool Passage::IsHighlighted() const
{
  return isHighlighted;
}

void Passage::SetHighlighted(bool value)
{
  if (isHighlighted != value)
  {
    isHighlighted = value;
    emit isHighlightedChanged();
  }
}

void Passage::SetInLane(int sideIndex, int laneIndex)
{
  inSideIndex = sideIndex;
  inLaneIndex = laneIndex;
  emit parametersChanged();
}

void Passage::SetOutLane(int sideIndex, int laneIndex)
{
  outSideIndex = sideIndex;
  outLaneIndex = laneIndex;
  emit parametersChanged();
}

void Passage::Clear()
{
  inSideIndex = -1;
  inLaneIndex = -1;
  outSideIndex = -1;
  outLaneIndex = -1;
  Curve::Clear();
  emit trajectoryReset();
  emit parametersChanged();
}

void Passage::Serialize(QTextStream &stream) const
{
  int pointsCount = rowCount();
  stream << inSideIndex << " " << inLaneIndex << " " << outSideIndex << " " << outLaneIndex << " "
         << pointsCount << Qt::endl;
  for (int i = 0; i < pointsCount; ++i)
    data(index(i, 0), DataRoles::RoadPointData).value<CurvePoint*>()->Serialize(stream);
}

bool Passage::AppendNewPoint(QPoint point)
{
  if (inSideIndex == -1 || inLaneIndex == -1)
  {
    qDebug() << "Cannot append new point to passage as first";
    return false; // can't be the first point
  }

  if (outSideIndex != -1 && outLaneIndex != -1)
  {
    qDebug() << "Cannot append new point to passage after last";
    return false; // can't be after the last point
  }

  AddPoint(point.x(), point.y());

  emit pointAppended();
  emit parametersChanged();
  return true;
}

bool Passage::AppendExistingPoint(int side, int lane, QPoint position)
{
  if (rowCount() == 0)
  {
    inSideIndex = side;
    inLaneIndex = lane;
    AddPoint(position.x(), position.y());

    emit pointAppended();
    emit parametersChanged();
    return true;
  }

  else if (outSideIndex == -1 && outLaneIndex == -1)
  {
    outSideIndex = side;
    outLaneIndex = lane;
    AddPoint(position.x(), position.y());

    emit pointAppended();
    emit parametersChanged();
    return true;
  }

  qDebug() << "Cannot append existing point to passage";
  return false;
}

bool Passage::RemoveLastPoint()
{
  if (rowCount() == 0)
    return false;

  if (!Curve::RemoveLastPoint())
    return false;

  if (outSideIndex != -1 && outLaneIndex != -1)
  {
    // removed the last point
    outSideIndex = -1;
    outLaneIndex = -1;
  }

  if (rowCount() == 0)
  {
    // removed the first point
    inSideIndex = -1;
    inLaneIndex = -1;
  }

  emit trajectoryReset();
  emit parametersChanged();
  return true;
}
