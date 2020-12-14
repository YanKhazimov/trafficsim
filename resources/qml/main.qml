import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "Constants"

ApplicationWindow {
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
        y: crossroadId.y - car.height
    }

    PropertyAnimation {
        running: true
        target: car
        property: "x"
        to: crossroadId.x + crossroadId.width - crossroad.Sides[0].InOffset - car.width
        duration: 3000
        easing.type: Easing.OutInCubic
    }

    PropertyAnimation {
        running: true
        target: car
        property: "rotation"
        to: 180
        duration: 3000
        easing.type: Easing.InBack
    }
}
