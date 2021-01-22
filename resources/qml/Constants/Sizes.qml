pragma Singleton
import QtQuick 2.12

QtObject {
    readonly property int laneWidth: 40
    readonly property int minMargin: 5

    function scaleToView(value) {
        return value * engine.ViewScale / 100
    }
    function scaleToMap(value) {
        return 100.0 / engine.ViewScale * value
    }

    function mapXToView(x, view) {
        return view.width / 2 + scaleToView(x - engine.ViewCenter.x)
    }
    function mapYToView(y, view) {
        return view.height / 2 + scaleToView(y - engine.ViewCenter.y)
    }
    function mapPointToView(point, view) {
        return Qt.point(mapXToView(point.x, view), mapYToView(point.y, view))
    }

    function mapXToModel(x, view) {
        return engine.ViewCenter.x + scaleToMap(x - view.width / 2)
    }
    function mapYToModel(y, view) {
        return engine.ViewCenter.y + scaleToMap(y - view.height / 2)
    }
    function mapPointToModel(point, view) {
        return Qt.point(mapXToModel(point.x, view), mapYToModel(point.y, view))
    }
}
