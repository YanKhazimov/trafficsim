import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
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
            model: engine.SelectedCar ? engine.SelectedCar.RoutePoints : []
            delegate: Rectangle {
                width: 4
                height: 4
                color: "yellow"
                x: modelData.x
                y: modelData.y
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
            engine.SelectedCar.X = crossroadId.x + engine.Crossroad.AtStopLine(side, inLane).x +
               engine.SelectedCar.Length * viewScale / 2 * Math.cos(engine.Crossroad.GetSide(side).NormalRadians)
            engine.SelectedCar.Y = crossroadId.y + engine.Crossroad.AtStopLine(side, inLane).y -
               engine.SelectedCar.Length * viewScale / 2 * Math.sin(engine.Crossroad.GetSide(side).NormalRadians)
            engine.SelectedCar.DirectionDegrees = (Math.PI/2 - engine.Crossroad.GetSide(side).NormalRadians + Math.PI) / Math.PI * 180
        }
        onCrossroadImageSaveRequested: {
            displayArea.grabToImage(function(grabResult) {
                grabResult.saveToFile("crossroad.png")
            }, Qt.size(displayArea.width, displayArea.height))
        }
    }
}
