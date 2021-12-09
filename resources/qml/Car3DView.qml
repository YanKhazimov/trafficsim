import QtQuick 2.15
import QtQuick3D 1.15

View3D {
    id: root

    implicitWidth: 800
    implicitHeight: 600
    renderMode: View3D.Offscreen
    environment: SceneEnvironment {
        clearColor: "#848895"
        backgroundMode: SceneEnvironment.Color
    }
}
