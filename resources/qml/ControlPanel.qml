import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as QQC1
import TrafficSimApp 1.0
import "Constants"

Rectangle {
    id: root
    color: "#BBBBBB"

    readonly property bool sideConstructionMode: constructorPanel.visible && constructorPanel.currentIndex === 0

    signal crossroadValidated()
    signal crossroadImageSaveRequested()

    function showConstructor() {
        constructorPanel.visible = true
        editButton.img = "qrc:/images/done.svg"
        editButton.callback = construct
    }

    function construct() {
        engine.Crossroad.Validate()
        root.crossroadValidated()

        constructorPanel.visible = false
        editButton.img = "qrc:/images/crossroad.svg"
        editButton.callback = showConstructor
    }

    Row {
        id: roadResultButtonsRow
        anchors.top: buttonsRow.bottom
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 20
        visible: false

        TSButton {
            id: canceButton
            height: 40
            text: "Cancel"
            callback: function() {
                roadResultButtonsRow.visible = false
                engine.RoadUnderConstruction.Clear()
                engine.EditorState = EditorState.NotEditing
            }
        }

        TSButton {
            id: createButton
            height: 40
            text: "Create"
            callback: function() {
                roadResultButtonsRow.visible = false
                engine.AddRoad()
                engine.EditorState = EditorState.NotEditing
            }
        }
    }

    Row {
        id: buttonsRow
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 20

        TSButton {
            id: createRoadButton
            width: 40
            height: 40
            img: "qrc:/images/road.svg"
            callback: function() {
                roadResultButtonsRow.visible = true
                engine.EditorState = EditorState.RoadCreation
            }
        }

        TSButton {
            id: editButton
            width: 40
            height: 40
            img: "qrc:/images/crossroad.svg"
            callback: showConstructor
        }

        TSButton {
            id: saveButton
            width: 40
            height: 40
            img: "qrc:/images/save.svg"
            callback: function() {
                engine.SaveMap()
                root.crossroadImageSaveRequested()
            }
        }

        TSButton {
            id: openButton
            width: 40
            height: 40
            img: "qrc:/images/open.svg"
            callback: function() {
                engine.OpenMap()
            }
        }
    }

    QQC1.TabView {
        id: constructorPanel
        visible: false
        anchors.top: buttonsRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 400
        anchors.margins: 20
        clip: true

        QQC1.Tab {
            title: "Sides"
            CrossroadConstructor {
                anchors.fill: parent
                anchors.margins: Sizes.minMargin
            }
        }

        QQC1.Tab {
            title: "Passages"
            PassageConstructor {
                id: pathsPanel
                anchors.fill: parent
                anchors.margins: Sizes.minMargin
            }
        }
    }
}
