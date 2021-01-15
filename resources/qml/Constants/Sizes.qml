pragma Singleton
import QtQuick 2.12

QtObject {
    readonly property int laneWidth: 40
    readonly property int minMargin: 5

    function scaleMapToView(value) {
        return value * engine.ViewScale / 100
    }

    function scaleViewToMap(value) {
        return 100.0 / engine.ViewScale * value
    }
}
