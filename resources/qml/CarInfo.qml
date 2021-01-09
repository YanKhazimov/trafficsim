import QtQuick 2.15
import QtQuick.Layouts 1.12
import TrafficSimApp 1.0
import "Constants"

Rectangle {
    id: root
    implicitWidth: 200
    implicitHeight: 200

    property CarModel model
    color: model === null ? "transparent" : "#DDDDDD"
    border.width: 1
    border.color: model === null ? "#DDDDDD" : "transparent"

    Text {
        id: placeholderText
        visible: model === null
        anchors.centerIn: parent
        text: "Select a car"
        font.pointSize: 14

        SequentialAnimation {
            running: true
            NumberAnimation { target: placeholderText; property: "opacity"; to: 0; duration: 1000 }
            NumberAnimation { target: placeholderText; property: "opacity"; to: 1; duration: 1000 }
            loops: Animation.Infinite
        }
    }

    TSButton {
        anchors.right: parent.right
        anchors.top: parent.top
        visible: model !== null
        width: 20
        height: 20
        text: "x"
        callback: function() {
            engine.Cars.Select(-1)
        }
    }

    ColumnLayout {
        visible: model !== null
        width: parent.width

        Image {
            id: img
            source: "qrc:/images/car.png"
            sourceSize.width: Sizes.laneWidth
        }

        Text {
            text: root.model ? ("x: " + root.model.X) : ""
        }

        Text {
            text: root.model ? ("y: " + root.model.Y) : ""
        }

        Text {
            text: root.model ? ("direction: " + root.model.DirectionDegrees) : ""
        }

        Text {
            text: root.model ? ("ReachedRoutePoint: " + root.model.ReachedRoutePoint) : ""
        }
    }
}
