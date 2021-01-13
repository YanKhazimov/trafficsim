import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import TrafficSimApp 1.0
import "Constants"

ApplicationWindow {
    id: root
    visible: true
    width: 1024
    height: 720
    title: qsTr("Hello World")
    color: "#666666"

    TSButton {
        width: 40
        height: 40
        img: "qrc:/images/next.svg"
        callback: function () {
            engine.GoToNextFrame()
        }
    }

    Rectangle {
        id: displayArea
        anchors.right: controlPanel.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 50
        color: "#BBBBBB"

        DrawArea {
            id: sideDrawingArea
            visible: controlPanel.sideConstructionMode
            anchors.fill: parent
        }

        Crossroad {
            id: crossroadId
            anchors.centerIn: sideDrawingArea

            Binding {
                target: engine.Crossroad
                property: "X"
                value: crossroadId.x
            }

            Binding {
                target: engine.Crossroad
                property: "Y"
                value: crossroadId.y
            }
        }

        Repeater {
            id: graphNodes
            model: engine.Graph.Nodes
            delegate: Rectangle {
                visible: engine.EditorState == EditorState.RouteCreation
                width: 10
                height: 10
                radius: 5
                x: RoleNodePosition.x - width/2
                y: RoleNodePosition.y - height/2
                color: "white"
                opacity: 0.5

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: engine.SelectedCar.AddRouteNode(RoleNodeData)
                }
            }
        }

        Repeater {
            model: engine.SelectedCar ? engine.SelectedCar.RoutePoints : []
            delegate: Rectangle {
                width: 10
                height: 10
                color: "white"
                radius: 5
                x: modelData.x - width/2
                y: modelData.y - height/2

                Text {
                    anchors.centerIn: parent
                    text: index + 1
                }
            }
        }

        Repeater {
            model: engine.Cars
            delegate: Car {
                model: modelData
                onClicked: engine.Cars.Select(index)
            }
        }
    }

    property int side: 2
    property int inLane: 0

    ControlPanel {
        id: controlPanel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 300

        onCrossroadValidated: {
            var viewScale = 1
            engine.SelectedCar.X = engine.Crossroad.AtStopLine(side, inLane).x +
               engine.SelectedCar.Length * viewScale / 2 * Math.cos(engine.Crossroad.GetSide(side).NormalRadians)
            engine.SelectedCar.Y = engine.Crossroad.AtStopLine(side, inLane).y -
               engine.SelectedCar.Length * viewScale / 2 * Math.sin(engine.Crossroad.GetSide(side).NormalRadians)
            engine.SelectedCar.DirectionDegrees = engine.Crossroad.GetSide(side).NormalDegrees + 180
        }
        onCrossroadImageSaveRequested: {
            displayArea.grabToImage(function(grabResult) {
                grabResult.saveToFile("crossroad.png")
            }, Qt.size(displayArea.width, displayArea.height))
        }
    }
}
