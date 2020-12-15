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

    Crossroad {
        id: crossroadId
        anchors.centerIn: parent
    }

    Image {
        id: car
        source: "qrc:/images/car.png"
        sourceSize.width: Sizes.laneWidth
    }

    PropertyAnimation {
        running: true
        target: car
        property: "x"
        to: crossroadId.x + crossroadId.atStopLine(0, 0).x +
            car.height/2 * Math.cos(crossroad.Sides[0].Normal) -
            car.width/2
        duration: 3000
        easing.type: Easing.OutInCubic
    }

    PropertyAnimation {
        running: true
        target: car
        property: "y"
        to: crossroadId.y + crossroadId.atStopLine(0, 0).y -
            car.height/2 * Math.sin(crossroad.Sides[0].Normal) -
            car.height/2
        duration: 3000
        easing.type: Easing.OutInCubic
    }

    PropertyAnimation {
        running: true
        target: car
        property: "rotation"
        to: (Math.PI/2 - crossroad.Sides[0].Normal + Math.PI) / Math.PI * 180
        duration: 3000
        easing.type: Easing.InBack
    }
}
