import QtQuick 2.0
import QtQuick.Shapes 1.12
import TrafficSimApp 1.0
import "Constants"

Item {
    id: root
    property CrossroadSideModel model

    readonly property point start: crossroadLine.start
    readonly property point end: Qt.point(start.x + crossroadLine.length * Math.cos(crossroadLine.angle),
                                      start.y - crossroadLine.length * Math.sin(crossroadLine.angle))

    Repeater {
        model: root.model.InLanes
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            Sizes.scaleToView(root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            Sizes.scaleToView(root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.sin(crossroadLine.angle)
                            )
            angle: root.model.NormalRadians
        }
    }

    Lane {
        color: "green"
        start: Qt.point(crossroadLine.start.x +
                        Sizes.scaleToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset/2) * Math.cos(crossroadLine.angle),
                        crossroadLine.start.y -
                        Sizes.scaleToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset/2) * Math.sin(crossroadLine.angle))
        w: Sizes.scaleToView(root.model.MidOffset)
        markup: false
        angle: root.model.NormalRadians
    }

    Repeater {
        id: outLanesRepeater
        model: root.model.OutLanes
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            Sizes.scaleToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            Sizes.scaleToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.sin(crossroadLine.angle))
            angle: root.model.NormalRadians
        }
    }

    Lane {
        id: stopLine
        length: root.model.InLanesCount * Sizes.scaleToView(Sizes.laneWidth)
        start: Qt.point(crossroadLine.start.x + Sizes.scaleToView(root.model.InOffset) * Math.cos(crossroadLine.angle)
                            + Sizes.scaleToView(15) * Math.cos(root.model.NormalRadians),
                        crossroadLine.start.y - Sizes.scaleToView(root.model.InOffset) * Math.sin(crossroadLine.angle)
                            - Sizes.scaleToView(15) * Math.sin(root.model.NormalRadians))
        angle: root.model.NormalRadians - Math.PI / 2
        color: Colors.markup
        w: Sizes.scaleToView(1)
        markup: false
    }

    Lane {
        id: crossroadLine
        length: Sizes.scaleToView(root.model.Length)
        start: Qt.point(-length/2 * Math.cos(angle), length/2 * Math.sin(angle))
        angle: root.model.NormalRadians - Math.PI / 2
        color: "green"
        w: Sizes.scaleToView(1)
        markup: false
    }

    CrossroadSideHighlighter {
        model: root.model
        crossroadSideItem: root
    }

    Rectangle {
        id: origin
        implicitHeight: 4
        implicitWidth: 4
        anchors.centerIn: parent
        color: "purple"
    }
}
