import QtQuick 2.0
import QtQuick.Shapes 1.12
import abc 1.0
import "Constants"

Item {
    id: root
    property CrossroadSideModel model

    Repeater {
        model: root.model.InLanesCount
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            (root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            (root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.sin(crossroadLine.angle)
                            )
            angle: root.model.Normal
        }
    }

    Lane {
        color: "green"
        start: Qt.point(crossroadLine.start.x +
                        (root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset/2) * Math.cos(crossroadLine.angle),
                        crossroadLine.start.y -
                        (root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset/2) * Math.sin(crossroadLine.angle))
        w: root.model.MidOffset
        markup: false
        angle: root.model.Normal
    }

    Repeater {
        model: root.model.OutLanesCount
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            (root.model._GetLength(Sizes.laneWidth) - root.model.OutOffset - Sizes.laneWidth/2 - Sizes.laneWidth * index) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            (root.model._GetLength(Sizes.laneWidth) - root.model.OutOffset - Sizes.laneWidth/2 - Sizes.laneWidth * index) * Math.sin(crossroadLine.angle))
            angle: root.model.Normal
        }
    }

    Lane {
        id: crossroadLine
        length: model._GetLength(Sizes.laneWidth)
        start: Qt.point(-length/2 * Math.cos(angle),
                        length/2 * Math.sin(angle))
        angle: root.model.Normal - Math.PI / 2
        color: "white"
        w: 1
        markup: false
    }
}
