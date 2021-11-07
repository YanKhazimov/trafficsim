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

    ColumnLayout {
        visible: model != null
        anchors.fill: parent
        anchors.margins: Sizes.minMargin

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            color: "transparent"

            Car3DView {
                id: view3d
                car3dSource: (root.model == null) ? "" : root.model.Source3d
                anchors.fill: parent
                anchors.margins: 2

                color: Qt.rgba(colorRSlider.value,
                                       colorGSlider.value,
                                       colorBSlider.value,
                                       colorASlider.value)
                metalness: metalnessSlider.value
                roughness: roughnessSlider.value
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
        anchors.bottom: parent.bottom
        visible: (model != null) && !root.carViewPopped
        text: view3d.topView ? "rotate" : "topView"
        callback: function() {
            view3d.topView = !view3d.topView
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
