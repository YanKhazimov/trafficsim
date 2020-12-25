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
            id: drawArea
            enabled: controlPanel.crossroadConstructionMode
            anchors.fill: parent

            Crossroad {
                id: crossroadId
                anchors.centerIn: parent
            }
        }
    }

    Image {
        id: car
        source: "qrc:/images/car.png"
        sourceSize.width: Sizes.laneWidth
        y: engine.Car.Y
        x: engine.Car.X
        rotation: engine.Car.DirectionDegrees
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
            engine.Car.X = displayArea.x + crossroadId.x + crossroadId.atStopLine(side, inLane).x +
               car.height/2 * Math.cos(engine.Crossroad.GetSide(side).NormalRadians) -
               car.width/2
            engine.Car.Y = displayArea.y + crossroadId.y + crossroadId.atStopLine(side, inLane).y -
               car.height/2 * Math.sin(engine.Crossroad.GetSide(side).NormalRadians) -
               car.height/2
            engine.Car.DirectionDegrees = (Math.PI/2 - engine.Crossroad.GetSide(side).NormalRadians + Math.PI) / Math.PI * 180
        }
        onCrossroadImageSaveRequested: {
            displayArea.grabToImage(function(grabResult) {
                grabResult.saveToFile("crossroad.png")
            }, Qt.size(displayArea.width, displayArea.height))
        }
    }
}
