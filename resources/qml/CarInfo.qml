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

    Binding {
        // passing user color to 2D image
        target: root.model
        property: "UserColor"
        value: Qt.rgba(colorRSlider.value,
                       colorGSlider.value,
                       colorBSlider.value,
                       150.0/255)
    }

    QtObject {
        id: carAppearance
        // passing user color to 3D scene
        property real metalness: metalnessSlider.value
        property real roughness: roughnessSlider.value
        property color color: Qt.rgba(colorRSlider.value,
                                      colorGSlider.value,
                                      colorBSlider.value,
                                      colorASlider.value)
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

    ColumnLayout {
        spacing: 5
        visible: model != null
        anchors.fill: parent
        anchors.margins: Sizes.minMargin

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
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
                Layout.alignment: Qt.AlignHCenter
                color: "transparent"
                border.color: "black"

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
            id: flow
            visible: root.carViewPopped
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: "Check All"
                onClicked: {
                    for (var i = 0; i < meshRepeater.count; ++i)
                        meshRepeater.itemAt(i).checked = true
                }
            }

            Button {
                text: "Uncheck All"
                onClicked: {
                    for (var i = 0; i < meshRepeater.count; ++i)
                        meshRepeater.itemAt(i).checked = false
                }
            }

            Repeater {
                id: meshRepeater
                delegate: CheckBox {
                    height: 10
                    text: modelData.source.toString().slice(26, -5)
                    checked: true
                    onCheckedChanged: modelData.visible = checked
                }
            }

            Button {
                text: "Snap"
                onClicked: {
                    snapRect.grabToImage(function(grabResult) {
                        grabResult.saveToFile("snap.png")
                    }, Qt.size(snapRect.width, snapRect.height))
                }
            }
        }

        Column {
            id: materialControl
            visible: root.carViewPopped

            Row {
                Text {
                    text: "metalness"
                }
                Slider {
                    id: metalnessSlider
                    from: 0.0
                    to: 1.0
                }

                Text {
                    text: "roughness"
                }
                Slider {
                    id: roughnessSlider
                    from: 0.0
                    to: 1.0
                }
            }

            Row {
                Text {
                    text: "r"
                }
                Slider {
                    id: colorRSlider
                    enabled: root.carViewPopped
                    from: 0.0
                    to: 1.0
                }

                Text {
                    text: "g"
                }
                Slider {
                    id: colorGSlider
                    enabled: root.carViewPopped
                    from: 0.0
                    to: 1.0
                }

                Text {
                    text: "b"
                }
                Slider {
                    id: colorBSlider
                    enabled: root.carViewPopped
                    from: 0.0
                    to: 1.0
                }

                Text {
                    text: "a"
                }
                Slider {
                    id: colorASlider
                    enabled: root.carViewPopped
                    from: 0.0
                    to: 1.0
                    value: 1.0
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
