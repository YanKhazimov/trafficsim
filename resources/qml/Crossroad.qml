import QtQuick 2.0
import QtQuick.Shapes 1.12
import "Constants"

Rectangle {
    id: root
    implicitHeight: 300
    implicitWidth: crossroad.Side.InOffset + crossroad.Side.InLanesCount * Sizes.laneWidth +
                   crossroad.Side.MidOffset + crossroad.Side.OutLanesCount * Sizes.laneWidth +
                   crossroad.Side.OutOffset

    color: "#EFEFEF"
    border.color: "cyan"
    border.width: 1

    Text {
        id: name
        text: root.width
    }

    Shape {
        vendorExtensionsEnabled: true

        ShapePath {
            id: crossroadSide
            strokeColor: "red"
            strokeWidth: 2
            startX: strokeWidth/2
            startY: strokeWidth/2

            PathLine {
                x: crossroadSide.startX + root.width - crossroadSide.strokeWidth/2
                y: crossroadSide.strokeWidth/2
            }
        }
    }

    Repeater {
        model: crossroad.Side.InLanesCount
        delegate: Lane {
            start: Qt.point(crossroad.Side.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index, 0)
            length: 100
        }
    }

    Shape {
        vendorExtensionsEnabled: true

        ShapePath {
            id: midLane
            strokeColor: "green"
            strokeWidth: crossroad.Side.MidOffset
            startX: crossroad.Side.InOffset + Sizes.laneWidth * crossroad.Side.InLanesCount + crossroad.Side.MidOffset/2
            startY: -strokeWidth/2

            PathLine {
                x: midLane.startX
                y: -100 + midLane.strokeWidth/2
            }
        }
    }

    Repeater {
        model: crossroad.Side.OutLanesCount
        delegate: Lane {
            start: Qt.point(root.width - crossroad.Side.OutOffset - Sizes.laneWidth/2 - Sizes.laneWidth * index, 0)
            length: 100
        }
    }
}
