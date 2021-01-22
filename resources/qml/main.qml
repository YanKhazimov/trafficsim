import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import TrafficSimApp 1.0
import "Constants"
import QtQuick.Shapes 1.12

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

        Keys.onPressed: {
            event.accepted = true

            if (event.key === Qt.Key_Plus)
                engine.ChangeViewScale(1)
            else if (event.key === Qt.Key_Minus)
                engine.ChangeViewScale(-1)
            else if (event.key === Qt.Key_Right)
                engine.ViewCenter.x += 10
            else if (event.key === Qt.Key_Left)
                engine.ViewCenter.x -= 10
            else if (event.key === Qt.Key_Up)
                engine.ViewCenter.y -= 10
            else if (event.key === Qt.Key_Down)
                engine.ViewCenter.y += 10
            else
                event.accepted = false
        }

        MouseArea {
            anchors.fill: parent
            onWheel: engine.ChangeViewScale(wheel.angleDelta.y / 120)
        }

        DrawArea {
            id: sideDrawingArea
            visible: controlPanel.sideConstructionMode
            anchors.fill: parent
        }

        Repeater {
            id: roadLanes
            model: engine.RoadLanes
            delegate: RoadLane {
                model: RoleRoadLaneData
                view: displayArea
            }
        }

        Connections {
            target: engine
            function onRoadLanesChanged() {
                roadLanes.model = []
                roadLanes.model = engine.RoadLanes
                for (var i = 0; i < roadLanes.count; ++i)
                    roadLanes.itemAt(i).update()
            }
        }

        Crossroad {
            id: crossroadId
            x: Sizes.mapXToView(engine.Crossroad.X, displayArea)
            y: Sizes.mapYToView(engine.Crossroad.Y, displayArea)
        }

        MouseArea {
            id: laneDrawingArea
            visible: engine.EditorState == EditorState.RoadCreation
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button == Qt.LeftButton)
                    engine.RoadUnderConstruction.AppendPoint(Sizes.mapPointToModel(Qt.point(mouseX, mouseY), displayArea), NodeType.RoadJoint)
                else if (mouse.button == Qt.RightButton)
                    engine.RoadUnderConstruction.RemoveLastPoint()
            }
        }

        RoadLane {
            id: roadUnderConstruction
            model: engine.RoadUnderConstruction
            shapeColor: "#88FF0000"
            view: displayArea
        }

        Repeater {
            id: graphNodes
            model: engine.Graph.Nodes
            delegate: Rectangle {
                visible: engine.EditorState == EditorState.RouteCreation ||
                         engine.EditorState == EditorState.RoadCreation
                width: 10
                height: 10
                radius: 5
                x: Sizes.mapXToView(RoleNodePosition.x, displayArea) - width/2
                y: Sizes.mapYToView(RoleNodePosition.y, displayArea) - height/2
                color: "white"
                opacity: 0.5

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (engine.EditorState == EditorState.RouteCreation)
                            engine.SelectedCar.AddRouteNode(RoleNodeData)
                        else if (engine.EditorState == EditorState.RoadCreation)
                            engine.RoadUnderConstruction.AppendPoint(RoleNodePosition, RoleNodeType)
                    }
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
                x: Sizes.mapXToView(modelData.x, displayArea) - width/2
                y: Sizes.mapYToView(modelData.y, displayArea) - height/2

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
                viewItem: displayArea
                onClicked: engine.Cars.Select(index)

                x: roadUnderConstruction.interpolatorX
                y: roadUnderConstruction.interpolatorY
                rotation: roadUnderConstruction.interpolatorAngle + 45
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
