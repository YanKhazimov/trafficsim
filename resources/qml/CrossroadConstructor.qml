import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

Column {
    id: root
    spacing: 10

    Repeater {
        id: sideRepeater
        model: engine.Crossroad.Sides
        delegate: MouseArea {
            id: delegateMouseArea
            width: parent.width
            height: sideInfo.height
            hoverEnabled: !inEditMode

            property bool inEditMode: false

            Rectangle {
                id: sideInfo
                width: parent.width
                height: childrenRect.height
                color: parent.containsMouse ? "#DDDDDD" : "transparent"

                Binding {
                    target: modelData
                    property: "IsHighlighted"
                    value: delegateMouseArea.containsMouse
                }

                ColumnLayout {
                    width: parent.width

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.StartX = modelData.StartX - 1
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "x: " + modelData.StartX
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.StartX = modelData.StartX + 1
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.StartY = modelData.StartY - 1
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "y: " + modelData.StartY
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.StartY = modelData.StartY + 1
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.NormalDegrees = modelData.NormalDegrees - 1
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "angle: " + modelData.NormalDegrees + "\u00B0"
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.NormalDegrees = modelData.NormalDegrees + 1
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.RemoveInLane()
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "in lanes: " + modelData.InLanesCount
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.AddInLane()
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.RemoveOutLane()
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "out lanes: " + modelData.OutLanesCount
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.AddOutLane()
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.InOffset = modelData.InOffset - 1
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "in margin: " + modelData.InOffset
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.InOffset = modelData.InOffset + 1
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.OutOffset = modelData.OutOffset - 1
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "out margin: " + modelData.OutOffset
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.OutOffset = modelData.OutOffset + 1
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "-"
                            onClicked: modelData.MidOffset = modelData.MidOffset - 1
                        }
                        Text {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "mid margin: " + modelData.MidOffset
                            font.pointSize: 14
                        }
                        Button {
                            visible: delegateMouseArea.inEditMode
                            Layout.maximumWidth: height
                            text: "+"
                            onClicked: modelData.MidOffset = modelData.MidOffset + 1
                        }
                    }

                    Button {
                        visible: !delegateMouseArea.inEditMode
                        width: height
                        icon.source: "qrc:/images/edit.svg"
                        onClicked: delegateMouseArea.inEditMode = true
                    }

                    Button {
                        visible: !delegateMouseArea.inEditMode
                        width: height
                        icon.source: "qrc:/images/remove.svg"
                        onClicked: engine.Crossroad.RemoveSide(index)
                    }
                }
            }
        }
    }
}
