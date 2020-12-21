import QtQuick 2.0
import QtQuick.Shapes 1.12
import abc 1.0
import "Constants"

Item {
    id: root
    property CrossroadSideModel model

    readonly property point start: crossroadLine.start
    readonly property point end: Qt.point(start.x + crossroadLine.length * Math.cos(crossroadLine.angle),
                                      start.y - crossroadLine.length * Math.sin(crossroadLine.angle))

    function atStopLine(inLaneNumber) {
        if (inLaneNumber >= model.InLanesCount) {
            console.error("Crossroad side does not have lane", inLaneNumber)
            return Qt.point(0, 0)
        }

        return Qt.point(stopLine.start.x + (0.5 + inLaneNumber) * Sizes.laneWidth * Math.cos(stopLine.angle),
                        stopLine.start.y - (0.5 + inLaneNumber) * Sizes.laneWidth * Math.sin(stopLine.angle))
    }

    Repeater {
        model: root.model.InLanes
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            (root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            (root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.sin(crossroadLine.angle)
                            )
            angle: root.model.NormalRadians
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
        angle: root.model.NormalRadians
    }

    Repeater {
        model: root.model.OutLanes
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            (root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            (root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.sin(crossroadLine.angle))
            angle: root.model.NormalRadians
        }
    }

    Lane {
        id: stopLine
        length: root.model.InLanesCount * Sizes.laneWidth
        start: Qt.point(crossroadLine.start.x + root.model.InOffset * Math.cos(crossroadLine.angle)
                            + 15 * Math.cos(root.model.NormalRadians),
                        crossroadLine.start.y- root.model.InOffset * Math.sin(crossroadLine.angle)
                            - 15 * Math.sin(root.model.NormalRadians))
        angle: root.model.NormalRadians - Math.PI / 2
        color: Colors.markup
        w: 1
        markup: false
    }

    Lane {
        id: crossroadLine
        length: root.model.Length
        start: Qt.point(-length/2 * Math.cos(angle), length/2 * Math.sin(angle))
        angle: root.model.NormalRadians - Math.PI / 2
        color: "green"
        w: 1
        markup: false
    }

    Image {
        id: origin
        source: "qrc:/images/gear.svg"
        x: -10
        y:-10
        width: 20
        height: 20
    }    

    Rectangle {
        id: highlighter
        x: -root.model.Length/2
        y: -root.model.Length/2
        width: root.model.Length
        height: root.model.Length
        radius: root.model.Length/2
        border.width: 2
        border.color: "#DDDDDD"
        color: "transparent"
        visible: root.model.IsHighlighted
    }
}
