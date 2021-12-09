import QtQuick 2.15
import QtQuick3D 1.15
import QtQml 2.15

Node {
    id: root

    property alias topViewCam: topViewCamera
    property alias perspectiveCam: perspectiveCamera
    property alias rotationAnimation: rotationAnimationId.running
    required property url car3dSource
    required property QtObject carLook
    property alias model3d: loader3d.item

    signal loaded(string source)

    DirectionalLight {
        id: dl
        ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
        rotation: Qt.quaternion(1, -1, 0, 0)
    }

//    Node {
//        PointLight {
//            id: topLight
//            color: Qt.rgba(0.2, 0.2, 0.2, 1.0)
//            ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
//            position: Qt.vector3d(0, 100, 0)
//            brightness: 100
//        }
//    }

//    Node {
//        PointLight {
//            id: leftLight
//            color: Qt.rgba(0.2, 0.2, 0.2, 1.0)
//            ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
//            position: Qt.vector3d(0, 0, 500)
//            brightness: 100
//        }
//    }

//    Node {
//        PointLight {
//            id: rightLight
//            color: Qt.rgba(0.2, 0.2, 0.2, 1.0)
//            ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
//            position: Qt.vector3d(0, 0, -500)
//            brightness: 100
//        }
//    }

//    Node {
//        PointLight {
//            id: frontLight
//            color: Qt.rgba(0.2, 0.2, 0.2, 1.0)
//            ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
//            position: Qt.vector3d(500, 0, 0)
//            brightness: 100
//        }
//    }

//    Node {
//        PointLight {
//            id: backLight
//            color: Qt.rgba(0.2, 0.2, 0.2, 1.0)
//            ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
//            position: Qt.vector3d(-500, 0, 0)
//            brightness: 100
//        }
//    }

    Loader3D {
        id: loader3d
        source: root.car3dSource
        onLoaded: {
            console.log("loaded", source)
            root.loaded(source)
        }
    }

    Binding {
        target: loader3d.item
        property: "color"
        value: carLook.color
        when: loader3d.status === Loader3D.Ready
        restoreMode: Binding.RestoreNone
    }
    Binding {
        target: loader3d.item
        property: "metalness"
        value: carLook.metalness
        when: loader3d.status === Loader3D.Ready
        restoreMode: Binding.RestoreNone
    }
    Binding {
        target: loader3d.item
        property: "roughness"
        value: carLook.roughness
        when: loader3d.status === Loader3D.Ready
        restoreMode: Binding.RestoreNone
    }

    Node {
        id: modelNode

        PerspectiveCamera {
            id: perspectiveCamera
            x: 300
            eulerRotation.x: -30
            eulerRotation.y: 90
            y: 60
        }

        PropertyAnimation on eulerRotation.y {
            id: rotationAnimationId
            loops: Animation.Infinite
            duration: 10000
            to: 0
            from: -360
        }
    }

    PerspectiveCamera {
        id: topViewCamera
        y: 300
    }
}
