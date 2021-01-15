import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import TrafficSimApp 1.0
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
        clip: true

        Component.onCompleted: forceActiveFocus()

        Keys.onRightPressed: engine.ViewCenter.x += 10
        Keys.onLeftPressed: engine.ViewCenter.x -= 10
        Keys.onUpPressed: engine.ViewCenter.y -= 10
        Keys.onDownPressed: engine.ViewCenter.y += 10

        MouseArea {
            anchors.fill: parent
            onWheel: engine.ChangeViewScale(wheel.angleDelta.y / 120)
        }

        DrawArea {
            id: sideDrawingArea
            visible: controlPanel.sideConstructionMode
            anchors.fill: parent
        }

        Crossroad {
            id: crossroadId
            x: displayArea.width / 2 + Sizes.scaleMapToView(engine.Crossroad.X - engine.ViewCenter.x)
            y: displayArea.height / 2 + Sizes.scaleMapToView(engine.Crossroad.Y - engine.ViewCenter.y)
        }

        Repeater {
            id: graphNodes
            model: engine.Graph.Nodes
            delegate: Rectangle {
                visible: engine.EditorState == EditorState.RouteCreation
                width: 10
                height: 10
                radius: 5
                x: displayArea.width / 2 + Sizes.scaleMapToView(RoleNodePosition.x) - width/2 - engine.ViewCenter.x
                y: displayArea.height / 2 + Sizes.scaleMapToView(RoleNodePosition.y) - height/2 - engine.ViewCenter.y
                color: "white"
                opacity: 0.5

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: engine.SelectedCar.AddRouteNode(RoleNodeData)
                }
            }
        }

        Repeater {
            model: engine.SelectedCar ? engine.SelectedCar.RoutePoints : []
            delegate: Rectangle {
                width: 10
                height: 10
                color: "white"
                radius: 5
                x: displayArea.width / 2 + Sizes.scaleMapToView(modelData.x) - width/2 - engine.ViewCenter.x
                y: displayArea.height / 2 + Sizes.scaleMapToView(modelData.y) - height/2 - engine.ViewCenter.y

                Text {
                    anchors.centerIn: parent
                    text: index + 1
                }
            }
        }

        Repeater {
            model: engine.Cars
            delegate: Car {
                model: modelData
                viewCenterOffset: Qt.point(displayArea.width / 2, displayArea.height / 2)
                onClicked: engine.Cars.Select(index)
            }
        }
    }

    MapRuler {
       mapSource: displayArea
    }

    ControlPanel {
        id: controlPanel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 300

        onCrossroadValidated: {
        }
        onCrossroadImageSaveRequested: {
            displayArea.grabToImage(function(grabResult) {
                grabResult.saveToFile("crossroad.png")
            }, Qt.size(displayArea.width, displayArea.height))
        }
    }
}
