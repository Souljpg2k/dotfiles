import qs.Appearance
import QtQuick

Item {
    id: root
    height: parent.height - 10

    Rectangle {
        anchors.fill: parent
        radius: Appearance.radius - 8
        color: Appearance.surface_container_high
        opacity: 0.3
    }
}