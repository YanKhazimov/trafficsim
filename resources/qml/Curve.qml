import QtQuick 2.15
import QtQuick.Shapes 1.12
import TrafficSimApp 1.0
import "Constants"

Shape
{
    id: root
    property CurveModel model // must be a Curve class instance // should be required but creating through repeater causes warnings
    property color shapeColor: Colors.lane
    property Item view // should be required but creating through repeater causes warnings
    readonly property alias interpolatorX: interpolator.x
    readonly property alias interpolatorY: interpolator.y
    readonly property alias interpolatorAngle: interpolator.angle
    property alias interpolatorProgress: interpolator.progress
    property real length: 0.0

    function updateLength(accuracy) {
        if (accuracy === undefined)
            accuracy = 0.02

        var calculatedLength = 0.0

        if (root.model.rowCount() > 1)
        {
            interpolatorProgress = 0.0
            var intervalStartX = interpolatorX
            var intervalStartY = interpolatorY
            var intervalEndX, intervalEndY

            while (interpolatorProgress < 1.0)
            {
                interpolatorProgress = Math.min(1.0, interpolatorProgress + accuracy)
                intervalEndX = interpolatorX
                intervalEndY = interpolatorY

                calculatedLength += Qt.vector2d(intervalStartX - intervalEndX, intervalStartY - intervalEndY).length()

                intervalStartX = intervalEndX
                intervalStartY = intervalEndY
            }
        }

        root.length = calculatedLength
    }

    ShapePath {
        id: shapePath

        strokeWidth: Sizes.scaleToView(Sizes.laneWidth)
        strokeColor: root.shapeColor
        fillColor: "transparent"
    }

    Repeater {
        id: pointRepeater
        model: []
        delegate: Rectangle {
            color: "yellow"
            width: 3
            height: 3
            x: Sizes.mapXToView(RoleNodePosition.x, view) - width/2
            y: Sizes.mapYToView(RoleNodePosition.y, view) - height/2
        }
    }

    function update() {
        pointRepeater.model = []
        pointRepeater.model = root.model

        shapePath.pathElements = []

        var size = root.model.rowCount()
        if (size < 1) {
            shapePath.startX = 0
            shapePath.startY = 0
            return
        }

        shapePath.startX = Sizes.mapXToView(root.model.GetPoint(0).x, view)
        shapePath.startY = Sizes.mapYToView(root.model.GetPoint(0).y, view)

        for(var i = 1; i < size; ++i)
        {
            var nextPoint = Sizes.mapPointToView(root.model.GetPoint(i), view)
            var pathCurve = Qt.createQmlObject('import QtQuick 2.15; PathCurve {}', shapePath);
            pathCurve.x = nextPoint.x
            pathCurve.y = nextPoint.y
            shapePath.pathElements.push(pathCurve)
        }

        interpolator.update()
        updateLength()
    }

    Connections {
        target: root.model

        function onPointAppended() {
            pointRepeater.model = []
            pointRepeater.model = root.model

            var size = root.model.rowCount()
            interpolator.progress = 1.0

            if (size < 1) {
                console.log("Trajectory size < 1")
                return
            }

            var lastPoint = Sizes.mapPointToView(root.model.GetPoint(size - 1), view)

            if (size === 1) {
                shapePath.startX = lastPoint.x
                shapePath.startY = lastPoint.y
            }
            else {
                var pathCurve = Qt.createQmlObject('import QtQuick 2.15; PathCurve {}', shapePath);
                pathCurve.x = lastPoint.x
                pathCurve.y = lastPoint.y
                shapePath.pathElements.push(pathCurve)
            }

            interpolator.update()
            updateLength()

            if (size > 1) {
                // changing the angle of the second to last point
                var distanceLast = root.model.GetDistanceTo(root.model.rowCount() - 1)
                var distancePreLast = root.model.GetDistanceTo(root.model.rowCount() - 2)
                interpolator.progress = distancePreLast / distanceLast
                root.model.SetAngle(root.model.rowCount() - 2, root.interpolatorAngle)
            }

            interpolator.progress = 1.0
            root.model.SetAngle(root.model.rowCount() - 1, root.interpolatorAngle)
        }

        function onTrajectoryReset() {
            root.update()
        }
    }

    Connections {
        target: engine

        function onViewCenterChanged() {
            root.update()
        }

        function onViewScaleChanged() {
            root.update()
        }
    }

    PathInterpolator {
        id: interpolator
        progress: 1.0
        path: Path {
            id: motionPath
            startX: shapePath.startX
            startY: shapePath.startY
        }
        NumberAnimation on progress {
            id: anim; running: false; from: 0; to: 1; duration: 5000
        }

        function update() {
            motionPath.startX = shapePath.startX
            motionPath.startY = shapePath.startY
            motionPath.pathElements = shapePath.pathElements
        }
    }

    TSButton {
        radius: 5
        x: 0
        y: 0
        text: "Animate"
        visible: root.model.rowCount() > 0
        callback: function () {
            interpolator.update()
            anim.start()
        }
    }

    Rectangle {
        visible: anim.running
        width: Sizes.scaleToView(50)
        height: Sizes.scaleToView(30)
        x: root.interpolatorX - width/2
        y: root.interpolatorY - height/2
        rotation: root.interpolatorAngle
    }
}
