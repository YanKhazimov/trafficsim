import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "Constants"

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 720
    title: qsTr("Hello World")
    color: "#666666"

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
/*
    Image {
        id: car
        source: "qrc:/images/car.png"
        sourceSize.width: Sizes.laneWidth
    }

    property int side: 0
    property int inLane: 1

    PropertyAnimation {
        running: true
        target: car
        property: "x"
        to: crossroadId.x + crossroadId.atStopLine(side, inLane).x +
            car.height/2 * Math.cos(crossroad.Sides[side].Normal) -
            car.width/2
        duration: 3000
        easing.type: Easing.OutInCubic
    }

    PropertyAnimation {
        running: true
        target: car
        property: "y"
        to: crossroadId.y + crossroadId.atStopLine(side, inLane).y -
            car.height/2 * Math.sin(crossroad.Sides[side].Normal) -
            car.height/2
        duration: 3000
        easing.type: Easing.OutInCubic
    }

    PropertyAnimation {
        running: true
        target: car
        property: "rotation"
        to: (Math.PI/2 - crossroad.Sides[side].Normal + Math.PI) / Math.PI * 180
        duration: 3000
        easing.type: Easing.InBack
    }
*/
    ControlPanel {
        id: controlPanel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 300

        onCrossroadValidated: crossroadId.fill();
    }
}
