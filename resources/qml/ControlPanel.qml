import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as QQC1
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
        editButton.img = "qrc:/images/edit.svg"
        editButton.callback = showConstructor
    }

    Row {
        id: buttonsRow
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 20

        TSButton {
            id: editButton
            width: 40
            height: 40
            img: "qrc:/images/edit.svg"
            callback: showConstructor
        }

        TSButton {
            id: saveButton
            width: 40
            height: 40
            img: "qrc:/images/save.svg"
            callback: function() {
                engine.SaveCrossroad()
                root.crossroadImageSaveRequested()
            }
        }

        TSButton {
            id: openButton
            width: 40
            height: 40
            img: "qrc:/images/open.svg"
            callback: function() {
                engine.OpenCrossroad()
            }
        }
    }

    QQC1.TabView {
        id: constructorPanel
        visible: false
        anchors.top: buttonsRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: carInfo.top
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

    CarInfo {
        id: carInfo
        model: engine.SelectedCar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
    }
}
