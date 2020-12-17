import QtQuick 2.0
import QtQuick.Shapes 1.12
import abc 1.0
import "Constants"

Item {
    id: root
    property CrossroadSideModel model

    readonly property point start: crossroadLine.start
    readonly property point end: Qt.point(start.x + crossroadLine.length * Math.cos(crossroadLine.angle),
                                      start.y- crossroadLine.length * Math.sin(crossroadLine.angle))

    function atStopLine(inLaneNumber) {
        if (inLaneNumber >= model.InLanesCount) {
            console.error("Crossroad side does not have lane", inLaneNumber)
            return Qt.point(0, 0)
        }

        return Qt.point(stopLine.start.x + (0.5 + inLaneNumber) * Sizes.laneWidth * Math.cos(stopLine.angle),
                        stopLine.start.y - (0.5 + inLaneNumber) * Sizes.laneWidth * Math.sin(stopLine.angle))
    }

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
        id: stopLine
        length: root.model.InLanesCount * Sizes.laneWidth
        start: Qt.point(crossroadLine.start.x + root.model.InOffset * Math.cos(crossroadLine.angle)
                            + 15 * Math.cos(root.model.Normal),
                        crossroadLine.start.y- root.model.InOffset * Math.sin(crossroadLine.angle)
                            - 15 * Math.sin(root.model.Normal))
        angle: root.model.Normal - Math.PI / 2
        color: Colors.markup
        w: 1
        markup: false
    }

    Lane {
        id: crossroadLine
        length: model._GetLength(Sizes.laneWidth)
        start: Qt.point(-length/2 * Math.cos(angle), length/2 * Math.sin(angle))
        angle: root.model.Normal - Math.PI / 2
        color: "green"
        w: 1
        markup: false
    }

    Rectangle {
        id: origin
        x: -4
        y:-4
        width: 8
        height: 8
        radius: 4

        ColorAnimation on color {
            from: "blue"
            to: "yellow"
            duration: 2000
            loops: Animation.Infinite
            running: true
        }
    }
}
