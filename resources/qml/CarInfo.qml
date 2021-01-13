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

    ColumnLayout {
        visible: model !== null
        anchors.fill: parent
        anchors.margins: Sizes.minMargin

        Item {
            id: placeholder
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Image {
                anchors.centerIn: parent
                source: root.model ? root.model.Source : ""
                rotation: root.model ? root.model.SourceDirection : 0.0
                height: root.model ? (root.model.SourceDirection / 90 % 2 === 0 ? undefined : parent.width/2) : undefined
                width: root.model ? (root.model.SourceDirection / 90 % 2 === 0 ? parent.width/2 : undefined) : undefined
                fillMode: Image.PreserveAspectFit
            }
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
            text: root.model ? ("route completion: %1/%2".arg(root.model.ReachedRoutePoint + 1).arg(root.model.RoutePoints.length)) : ""
        }

        TSButton {
            text: "Assign route"
            callback: function() {
                engine.EditorState = EditorState.RouteCreation
            }
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
            engine.EditorState = EditorState.NotEditing
        }
    }
}
