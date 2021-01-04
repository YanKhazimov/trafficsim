import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import TrafficSimApp 1.0
import "Constants"

ScrollView {
    id: root
    implicitHeight: 500
    contentWidth: availableWidth

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: 15

        Rectangle {
            id: newPathInfo
            Layout.fillWidth: true
            Layout.minimumHeight: childrenRect.height
            Layout.maximumHeight: childrenRect.height
            radius: 10
            color: "grey"
            clip: true

            property bool inSourceSelected: engine.Crossroad.PassageUnderConstruction.InSideIndex !== -1 &&
                                            engine.Crossroad.PassageUnderConstruction.InLaneIndex !== -1
            property bool outSourceSelected: engine.Crossroad.PassageUnderConstruction.OutSideIndex !== -1 &&
                                             engine.Crossroad.PassageUnderConstruction.OutLaneIndex !== -1

            Behavior on height {
                PropertyAnimation {}
            }

            ColumnLayout {
                width: parent.width

                RowLayout {
                    width: parent.width
                    spacing: 0

                    TSButton {
                        id: icon
                        property bool open: false
                        img: open ? "qrc:/images/done.svg" : "qrc:/images/plus.svg"
                        width: 20
                        height: 20
                        callback: function() {
                            inRow.visible = !open
                            outRow.visible = !open

                            if (open)
                                engine.Crossroad.ConstructPassage()

                            open = !open
                        }
                    }
                    Text {
                        id: newInfoText
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        text: "New pass"
                        font.pointSize: 16
                        color: "white"
                    }
                }

                RowLayout {
                    id: inRow
                    visible: false
                    spacing: Sizes.minMargin

                    Text {
                        text: "In lane:"
                        font.pointSize: 14
                        color: "white"
                    }

                    Text {
                        visible: newPathInfo.inSourceSelected
                        text: engine.Crossroad.PassageUnderConstruction.InSideIndex + ":" + engine.Crossroad.PassageUnderConstruction.InLaneIndex
                    }

                    TSButton {
                        id: inLaneSelector
                        text: newPathInfo.inSourceSelected ? "Change" : "Select"
                        callback: function() {
                            engine.EditorState = EditorState.InLaneSelection
                        }
                    }
                }

                RowLayout {
                    id: outRow
                    visible: false
                    spacing: Sizes.minMargin

                    Text {
                        text: "Out lane:"
                        font.pointSize: 14
                        color: "white"
                    }

                    Text {
                        visible: newPathInfo.outSourceSelected
                        text: engine.Crossroad.PassageUnderConstruction.OutSideIndex + ":" + engine.Crossroad.PassageUnderConstruction.OutLaneIndex
                    }

                    TSButton {
                        id: outLaneSelector
                        text: newPathInfo.outSourceSelected ? "Change" : "Select"
                        callback: function() {
                            engine.EditorState = EditorState.OutLaneSelection
                        }
                    }
                }
            }
        }

        ListView {
            id: passageList
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 200
            Connections {
                target: engine.Crossroad
                function onPassagesChanged() {
                    console.log("passageList.height", passageList.height, "column.height", column.height)
                }
            }
            model: engine.Crossroad.Passages
            spacing: 15
            delegate: MouseArea {
                id: delegateMouseArea
                width: passageList.width
                height: passageInfo.height
                hoverEnabled: true

                Binding {
                    target: RolePassageData
                    property: "IsHighlighted"
                    value: delegateMouseArea.containsMouse
                }

                Rectangle {
                    id: passageInfo
                    width: parent.width
                    height: infoText.height + 2 * Sizes.minMargin
                    color: parent.containsMouse ? "#DDDDDD" : "grey"

                    Text {
                        id: infoText
                        text: "Passage #%1 (from %2:%3 to %4:%5)".arg(index + 1).arg(RolePassageData.InSideIndex).arg(RolePassageData.InLaneIndex).arg(RolePassageData.OutSideIndex).arg(RolePassageData.OutLaneIndex)
                        color: "white"
                        anchors {
                            left: parent.left; leftMargin: Sizes.minMargin
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    TSButton {
                        anchors {
                            right: parent.right; rightMargin: 10
                            top: parent.top; topMargin: -10
                        }

                        img: "qrc:/images/remove.svg"
                        callback: function() {
                            engine.Crossroad.RemovePassage(index)
                        }
                    }
                }
            }
        }
    }
}
