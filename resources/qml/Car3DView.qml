import QtQuick 2.15
import QtQuick3D 1.15

View3D {
    id: root
    required property url car3dSource
    property alias metalness: carAppearance.metalness
    property alias roughness: carAppearance.roughness
    property alias color: carAppearance.color
    property bool topView: false

    state: topView ? "topDown" : "perspective"

    onTopViewChanged: if (topView) scene.topViewCam.lookAt(Qt.vector3d(0, 0, 0))

    QtObject {
        id: carAppearance
        property real metalness
        property real roughness
        property color color
    }

    implicitWidth: 800
    implicitHeight: 600
    camera: topView ? scene.topViewCam : scene.perspectiveCam
    importScene: CarScene3D {
        id: scene
        car3dSource: root.car3dSource
        carLook: carAppearance
    }
    renderMode: View3D.Offscreen
    environment: SceneEnvironment {
        clearColor: "#848895"
        backgroundMode: SceneEnvironment.Color
    }

    states: [
        State {
            name: "topDown"
            PropertyChanges {
                target: root
                camera: scene.topViewCam
            }
            PropertyChanges {
                target: scene
                rotationAnimation: false
            }
        },
        State {
            name: "perspective"
            PropertyChanges {
                target: root
                camera: scene.perspectiveCam
            }
            PropertyChanges {
                target: scene
                rotationAnimation: true
            }
        }
    ]
}
