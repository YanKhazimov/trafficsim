import QtQuick 2.0
import QtQuick.Controls 2.15

Column {
    id: root

    Repeater {
        id: sideRepeater
        model: 1
        delegate: Row {
            spacing: 10

            TextEdit {
                id: startXInput
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "-50"
                selectByMouse: true
            }
            TextEdit {
                id: startYInput
                inputMethodHints: Qt.ImhDigitsOnly
                text: "-50"
                selectByMouse: true
            }
            TextEdit {
                id: normalInput
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: "95.0"
                selectByMouse: true
            }
            TextEdit {
                id: inLanesInput
                inputMethodHints: Qt.ImhDigitsOnly
                text: "2"
                selectByMouse: true
            }
            TextEdit {
                id: outLanesInput
                inputMethodHints: Qt.ImhDigitsOnly
                text: "1"
                selectByMouse: true
            }
            TextEdit {
                id: inOffsetInput
                inputMethodHints: Qt.ImhDigitsOnly
                text: "100"
                selectByMouse: true
            }
            TextEdit {
                id: outOffsetInput
                inputMethodHints: Qt.ImhDigitsOnly
                text: "10"
                selectByMouse: true
            }
            TextEdit {
                id: midOffsetInput
                inputMethodHints: Qt.ImhDigitsOnly
                text: "10"
                selectByMouse: true
            }
            Button {
                width: height
                icon.source: "qrc:/images/hammer.svg"
                onClicked: engine.Crossroad.AddSide(startXInput.text, startYInput.text, normalInput.text, inLanesInput.text, outLanesInput.text,
                                             inOffsetInput.text, outOffsetInput.text, midOffsetInput.text)
            }
        }
    }

    Button {
        width: height
        icon.source: "qrc:/images/plus.svg"
        onClicked: sideRepeater.model = sideRepeater.model + 1
    }
}
