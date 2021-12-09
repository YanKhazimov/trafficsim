import QtQuick 2.15
import QtQuick.Layouts 1.12
import TrafficSimApp 1.0
import QtQuick.Controls 2.12
import "Constants"

Rectangle {
    id: root
    implicitWidth: 200
    implicitHeight: 200

    property CarModel model
    color: model == null ? "transparent" : "#DDDDDD"
    border.width: 1
    border.color: model == null ? "#DDDDDD" : "transparent"
    property bool carViewPopped: false

    Text {
        id: placeholderText
        visible: model == null
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

    QtObject {
        id: carAppearance
        property real metalness: metalnessSlider.value
        property real roughness: roughnessSlider.value
        property color color: !root.model ? "transparent" :
                                            Qt.rgba(root.model.UserColor.r,
                                                    root.model.UserColor.g,
                                                    root.model.UserColor.b,
                                                    1)
    }

    CarScene3D {
        id: scene
        car3dSource: (root.model == null) ? "" : root.model.Source3d
        carLook: carAppearance
        onLoaded: {
            if (scene.model3d)
                meshRepeater.model = scene.model3d.meshes
        }
    }

    Item {
        id: rightHalf

        height: parent.height
        width: parent.width / 2
        anchors.right: parent.right

        ColumnLayout {
            spacing: 5
            visible: model != null
            anchors.fill: parent
            anchors.margins: Sizes.minMargin

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: root.carViewPopped
                clip: true

                Flow {
                    id: flow
                    anchors.fill: parent
                    spacing: 10

                    TSButton {
                        text: "Check All"
                        callback: function() {
                            for (var i = 0; i < meshRepeater.count; ++i)
                                meshRepeater.itemAt(i).checked = true
                        }
                    }

                    TSButton {
                        text: "Uncheck All"
                        callback: function() {
                            for (var i = 0; i < meshRepeater.count; ++i)
                                meshRepeater.itemAt(i).checked = false
                        }
                    }

                    TSButton {
                        text: "Snap"
                        callback: function() {
                            snapRect.grabToImage(function(grabResult) {
                                grabResult.saveToFile("snap.png")
                            }, Qt.size(snapRect.width, snapRect.height))
                        }
                    }

                    Repeater {
                        id: meshRepeater
                        delegate: CheckBox {
                            height: 10
                            text: engine.CropFilename(modelData.source)
                            checked: true
                            onCheckedChanged: modelData.visible = checked
                        }
                    }
                }
            }

            Column {
                id: info
                visible: !root.carViewPopped

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
        }
    }

    Item {
        id: leftHalf

        height: parent.height
        width: parent.width / 2
        anchors.left: parent.left

        ColumnLayout {
            spacing: 5
            visible: model != null
            anchors.fill: parent
            anchors.margins: Sizes.minMargin

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                    border.color: "black"

                    Car3DView {
                        id: view3d
                        importScene: scene
                        camera: scene.perspectiveCam
                        anchors.fill: parent
                        anchors.margins: 2
                    }
                }

                Rectangle {
                    id: snapRect
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                    border.color: "black"
                    visible: root.carViewPopped

                    Car3DView {
                        id: viewTop
                        state: "topDown"
                        importScene: scene
                        camera: scene.topViewCam
                        anchors.fill: parent
                        anchors.margins: 2

                        Component.onCompleted: scene.topViewCam.lookAt(Qt.vector3d(0, 0, 0))
                    }
                }
            }

            Flow {
                id: palette
                spacing: 5
                Layout.fillWidth: true

                Repeater {
                    model: [
                        Colors.whiteCar,
                        Colors.silverCar,
                        Colors.greyCar,
                        Colors.cherryCar,
                        Colors.redCar,
                        Colors.orangeCar,
                        Colors.brownCar,
                        Colors.yellowCar,
                        Colors.biegeCar,
                        Colors.purpleCar,
                        Colors.blueCar,
                        Colors.cyanCar,
                        Colors.emeraldCar,
                        Colors.tealCar,
                        Colors.darkBlueCar,
                        Colors.blackCar
                    ]

                    delegate: Rectangle {
                        width: 20
                        height: 20
                        color: modelData

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: -5
                            color: "transparent"
                            border.width: 2
                            border.color: "black"
                            visible: root.model && Qt.colorEqual(Qt.rgba(modelData.r, modelData.g, modelData.b),
                                                                 Qt.rgba(root.model.UserColor.r, root.model.UserColor.g, root.model.UserColor.b))
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.model.UserColor = modelData
                        }
                    }
                }
            }

            Rectangle {
                id: lightingSwitch

                visible: !root.carViewPopped
                height: 20
                width: 100
                radius: 5
                color: "grey"
                property bool on: false

                Binding {
                    target: root.model
                    property: "Lighting"
                    value: lightingSwitch.on
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: lightingSwitch.on = !lightingSwitch.on
                }

                Rectangle {
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        margins: 2
                    }

                    x: lightingSwitch.on ? (lightingSwitch.width - anchors.margins - width) : anchors.margins
                    Behavior on x {
                        NumberAnimation {
                            duration: 300
                        }
                    }

                    radius: 5
                    color: "lightgrey"
                    width: 70

                    Text {
                        text: "Lighting" + (lightingSwitch.on ? " ON" : " OFF")
                        anchors.centerIn: parent
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: root.carViewPopped

                Text {
                    text: "metalness"
                }
                Slider {
                    id: metalnessSlider
                    Layout.fillWidth: true
                    from: 0.0
                    to: 1.0
                    value: 0.3
                }

                Text {
                    text: "roughness"
                }
                Slider {
                    id: roughnessSlider
                    Layout.fillWidth: true
                    from: 0.0
                    to: 1.0
                    value: 0.4
                }
            }
        }
    }

    TSButton {
        anchors.right: parent.right
        anchors.top: parent.top
        visible: (model != null) && !root.carViewPopped
        width: 20
        height: 20
        text: "x"
        callback: function() {
            engine.Cars.Select(-1)
            engine.EditorState = EditorState.NotEditing
        }
    }

    TSButton {
        anchors.left: parent.left
        anchors.top: parent.top
        visible: model != null
        img: root.carViewPopped ? "qrc:/images/done.svg" : "qrc:/images/edit.svg"
        callback: function() {
            root.carViewPopped = !root.carViewPopped
        }
    }
}
