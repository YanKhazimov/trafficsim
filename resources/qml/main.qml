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

    function roadLaneLength(laneIndex) {
        if (laneIndex >= 0 && laneIndex < roadLanes.count)
        {
            return Sizes.scaleToMap(roadLanes.itemAt(laneIndex).length)
        }

        console.warn("Can't get length for road lane", laneIndex)
        return 0
    }

    function roadLaneCoords(laneIndex, laneProgress) {
        if (laneIndex >= 0 && laneIndex < roadLanes.count)
        {
            var lane = roadLanes.itemAt(laneIndex)
            lane.interpolatorProgress = laneProgress
            var map = {}
            map["x"] = Sizes.mapXToModel(lane.interpolatorX, displayArea)
            map["y"] = Sizes.mapYToModel(lane.interpolatorY, displayArea)
            map["rotation"] = lane.interpolatorAngle
            return map
        }
        console.warn("Can't get coords for road lane", laneIndex)
        return []
    }

    function passageLength(laneIndex) {
        if (laneIndex >= 0 && laneIndex < passagesRepeater.count)
        {
            return Sizes.scaleToMap(passagesRepeater.itemAt(laneIndex).length)
        }

        console.warn("Can't get length for passage", laneIndex)
        return 0
    }

    function passageCoords(laneIndex, laneProgress) {
        if (laneIndex >= 0 && laneIndex < passagesRepeater.count)
        {
            var lane = passagesRepeater.itemAt(laneIndex)
            lane.interpolatorProgress = laneProgress
            var map = {}
            map["x"] = Sizes.mapXToModel(lane.interpolatorX, displayArea)
            map["y"] = Sizes.mapYToModel(lane.interpolatorY, displayArea)
            map["rotation"] = lane.interpolatorAngle
            return map
        }
        console.warn("Can't get coords for passage", laneIndex)
        return []
    }

    Row {
    TSButton {
        text: "Next frame"
        callback: function () {
            engine.GoToNextFrame()
        }
    }
    TSButton {
        text: "Move along lane 1"
        callback: function () {
            engine.MoveAlongLane()
        }
    }
    TSButton {
        text: "Move along passage 0"
        callback: function () {
            engine.MoveAlongPassage0()
        }
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

        Connections {
            target: engine
            function onRoadLanesChanged() {
                roadLanes.model = []
                roadLanes.model = engine.RoadLanes
                for (var i = 0; i < roadLanes.count; ++i)
                    roadLanes.itemAt(i).update()
            }
        }

        Repeater {
            id: roadLanes
            model: engine.RoadLanes
            delegate: Curve {
                model: RoleRoadLaneData
                view: displayArea
            }
        }

        /* a crossroad start */
        Crossroad {
            id: crossroadId
            x: Sizes.mapXToView(engine.Crossroad.X, displayArea)
            y: Sizes.mapYToView(engine.Crossroad.Y, displayArea)
        }
        Repeater {
            id: passagesRepeater
            model: engine.Crossroad.Passages
            delegate: Curve {
                model: RolePassageData
                view: displayArea
                shapeColor: "#DDDDDD"
                visible: RoleIsHighlighted
            }
        }
        Connections {
            target: engine.Crossroad
            function onPassagesChanged() {
                passagesRepeater.model = []
                passagesRepeater.model = engine.Crossroad.Passages
                for (var i = 0; i < passagesRepeater.count; ++i) {
                    passagesRepeater.itemAt(i).update()
                }
            }
        }
        /* a crossroad end */

        MouseArea {
            id: laneDrawingArea
            visible: engine.EditorState == EditorState.RoadCreation
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button == Qt.LeftButton)
                    engine.RoadUnderConstruction.AppendNewPoint(Sizes.mapPointToModel(Qt.point(mouseX, mouseY), displayArea), NodeType.RoadJoint)
                else if (mouse.button == Qt.RightButton)
                    engine.RoadUnderConstruction.RemoveLastPoint()
            }
        }

        Curve {
            id: roadUnderConstruction
            model: engine.RoadUnderConstruction
            shapeColor: "#88FF0000"
            view: displayArea
        }

        MouseArea {
            id: passageDrawingArea
            visible: engine.EditorState == EditorState.PassageCreation
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button == Qt.LeftButton)
                    engine.Crossroad.PassageUnderConstruction.AppendNewPoint(Sizes.mapPointToModel(Qt.point(mouseX, mouseY), displayArea))
                else if (mouse.button == Qt.RightButton)
                    engine.Crossroad.PassageUnderConstruction.RemoveLastPoint()
            }
        }

        Curve {
            id: passageUnderConstruction
            model: engine.Crossroad.PassageUnderConstruction
            shapeColor: "#8800FF00"
            view: displayArea
        }

        Repeater {
            id: graphNodes
            model: engine.Graph.Nodes
            delegate: Rectangle {
                visible: engine.EditorState === EditorState.RouteCreation ||
                         engine.EditorState === EditorState.RoadCreation ||
                         engine.EditorState === EditorState.PassageCreation
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
                        if (engine.EditorState === EditorState.RouteCreation)
                            engine.SelectedCar.AddRouteNode(RoleNodeData)
                        else if (engine.EditorState === EditorState.RoadCreation)
                            engine.RoadUnderConstruction.AppendExistingPoint(RoleNodeSide, RoleNodeLane, RoleNodeType, RoleNodeAngle, RoleNodeCrossroad, RoleNodePosition)
                        else if (engine.EditorState === EditorState.PassageCreation)
                            engine.Crossroad.PassageUnderConstruction.AppendExistingPoint(RoleNodeSide, RoleNodeLane, RoleNodePosition)
                    }
                }
            }
        }

        Repeater {
            model: engine.SelectedCar ? engine.SelectedCar.RoutePoints : []
            delegate: Rectangle {
                width: Sizes.laneWidth/2
                height: Sizes.laneWidth/2
                color: "white"
                radius: 5
                x: Sizes.mapXToView(modelData.x, displayArea) - width/2
                y: Sizes.mapYToView(modelData.y, displayArea) - height/2

                Text {
                    anchors.centerIn: parent
                    text: index + 1
                    font.pixelSize: Sizes.laneWidth/2
                }
            }
        }

        Repeater {
            model: engine.Cars
            delegate: Car {
                model: modelData
                viewItem: displayArea
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
