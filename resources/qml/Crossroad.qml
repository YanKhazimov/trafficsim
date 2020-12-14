import QtQuick 2.0
import QtQuick.Shapes 1.12
import "Constants"

Rectangle {
    id: root
    implicitHeight: 300
    implicitWidth: crossroad.Side1.GetLength(Sizes.laneWidth)

    color: Colors.lane

    Text {
        id: name
        text: root.width
        color: "white"
    }
// side 1
    Lane {
        start: Qt.point(0, 0)
        length: root.width
        angle: 0
        color: "white"
        w: 1
        markup: false
    }

    Repeater {
        model: crossroad.Side1.InLanesCount
        delegate: Lane {
            start: Qt.point(crossroad.Side1.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index, 0)
            length: 100
        }
    }

    Lane {
        color: "green"
        start: Qt.point(crossroad.Side1.InOffset + Sizes.laneWidth * crossroad.Side1.InLanesCount + crossroad.Side1.MidOffset/2, 0)
        w: crossroad.Side1.MidOffset
    }

    Repeater {
        model: crossroad.Side1.OutLanesCount
        delegate: Lane {
            start: Qt.point(root.width - crossroad.Side1.OutOffset - Sizes.laneWidth/2 - Sizes.laneWidth * index, 0)
            length: 100
        }
    }
    // side 2

    Repeater {
        model: crossroad.Side2.InLanesCount
        delegate: Lane {
            start: Qt.point(side2.start.x +
                            (crossroad.Side2.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.cos(Math.PI * 5/4),
                            side2.start.y -
                            (crossroad.Side2.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.sin(Math.PI * 5/4)
                            )
            length: 100
            angle: -Math.PI / 4
        }
    }

    Lane {
        color: "green"
        start: Qt.point(side2.start.x +
                        (crossroad.Side2.InOffset + Sizes.laneWidth * crossroad.Side2.InLanesCount + crossroad.Side2.MidOffset/2) * Math.cos(Math.PI * 5/4),
                        side2.start.y -
                        (crossroad.Side2.InOffset + Sizes.laneWidth * crossroad.Side2.InLanesCount + crossroad.Side2.MidOffset/2) * Math.sin(Math.PI * 5/4))
        w: crossroad.Side2.MidOffset
        angle: -Math.PI / 4
    }

    Repeater {
        model: crossroad.Side2.OutLanesCount
        delegate: Lane {
            start: Qt.point(side2.start.x +
                            (crossroad.Side2.GetLength(Sizes.laneWidth) - crossroad.Side2.OutOffset - Sizes.laneWidth/2 - Sizes.laneWidth * index) * Math.cos(Math.PI * 5/4),
                            side2.start.y -
                            (crossroad.Side2.GetLength(Sizes.laneWidth) - crossroad.Side2.OutOffset - Sizes.laneWidth/2 - Sizes.laneWidth * index) * Math.sin(Math.PI * 5/4))
            length: 100
            angle: -Math.PI / 4
        }
    }
    Lane {
        id: side2
        start: Qt.point(root.width, root.height/2)
        length: crossroad.Side2.GetLength(Sizes.laneWidth)
        angle: Math.PI * 5/4
        color: "white"
        w: 1
        markup: false
    }
}
