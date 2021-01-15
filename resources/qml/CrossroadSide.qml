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

    signal inLaneClicked(int laneIndex)
    signal outLaneClicked(int laneIndex)

    Repeater {
        model: root.model.InLanes
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.sin(crossroadLine.angle)
                            )
            angle: root.model.NormalRadians

            Rectangle {
                id: inDelegateRect
                visible: engine.EditorState == EditorState.InLaneSelection
                width: Sizes.scaleMapToView(100)
                height: Sizes.scaleMapToView(Sizes.laneWidth)
                x: crossroadLine.start.x + Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.cos(crossroadLine.angle)
                   + Sizes.scaleMapToView(100 / 2) * Math.cos(root.model.NormalRadians)
                   - width / 2
                y: crossroadLine.start.y - Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth/2 + Sizes.laneWidth * index) * Math.sin(crossroadLine.angle)
                   - Sizes.scaleMapToView(100 / 2) * Math.sin(root.model.NormalRadians)
                   - height / 2
                rotation: -root.model.NormalDegrees

                color: inLaneMouseArea.containsMouse ? "cyan" : "transparent"

                MouseArea {
                    id: inLaneMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.inLaneClicked(index)
                }
            }
        }
    }

    Lane {
        color: "green"
        start: Qt.point(crossroadLine.start.x +
                        Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset/2) * Math.cos(crossroadLine.angle),
                        crossroadLine.start.y -
                        Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset/2) * Math.sin(crossroadLine.angle))
        w: Sizes.scaleMapToView(root.model.MidOffset)
        markup: false
        angle: root.model.NormalRadians
    }

    Repeater {
        id: outLanesRepeater
        model: root.model.OutLanes
        delegate: Lane {
            start: Qt.point(crossroadLine.start.x +
                            Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.cos(crossroadLine.angle),
                            crossroadLine.start.y -
                            Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.sin(crossroadLine.angle))
            angle: root.model.NormalRadians

            Rectangle {
                id: outDelegateRect
                visible: engine.EditorState == EditorState.OutLaneSelection
                width: Sizes.scaleMapToView(100)
                height: Sizes.scaleMapToView(Sizes.laneWidth)
                x: crossroadLine.start.x + Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.cos(crossroadLine.angle)
                   + Sizes.scaleMapToView(100 / 2) * Math.cos(root.model.NormalRadians)
                   - width / 2
                y: crossroadLine.start.y - Sizes.scaleMapToView(root.model.InOffset + Sizes.laneWidth * root.model.InLanesCount + root.model.MidOffset + Sizes.laneWidth * (0.5 + root.model.OutLanesCount - 1 - index)) * Math.sin(crossroadLine.angle)
                   - Sizes.scaleMapToView(100 / 2) * Math.sin(root.model.NormalRadians)
                   - height / 2
                rotation: -root.model.NormalDegrees

                color: outLaneMouseArea.containsMouse ? "pink" : "transparent"

                MouseArea {
                    id: outLaneMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.outLaneClicked(index)
                }
            }
        }
    }

    Lane {
        id: stopLine
        length: root.model.InLanesCount * Sizes.scaleMapToView(Sizes.laneWidth)
        start: Qt.point(crossroadLine.start.x + Sizes.scaleMapToView(root.model.InOffset) * Math.cos(crossroadLine.angle)
                            + Sizes.scaleMapToView(15) * Math.cos(root.model.NormalRadians),
                        crossroadLine.start.y - Sizes.scaleMapToView(root.model.InOffset) * Math.sin(crossroadLine.angle)
                            - Sizes.scaleMapToView(15) * Math.sin(root.model.NormalRadians))
        angle: root.model.NormalRadians - Math.PI / 2
        color: Colors.markup
        w: Sizes.scaleMapToView(1)
        markup: false
    }

    Lane {
        id: crossroadLine
        length: Sizes.scaleMapToView(root.model.Length)
        start: Qt.point(-length/2 * Math.cos(angle), length/2 * Math.sin(angle))
        angle: root.model.NormalRadians - Math.PI / 2
        color: "green"
        w: Sizes.scaleMapToView(1)
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
