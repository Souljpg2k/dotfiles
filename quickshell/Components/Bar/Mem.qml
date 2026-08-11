import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick

StyledItem {
    Rectangle {
        id: memRect
        anchors.fill: parent
        radius: Appearance.radius
        color: Appearance.surface_container_high

        CircleProgress { progress: MemService.memUsage / 100 }

        MaterialIcon {
            anchors.centerIn: parent
            text: "memory"
        }
    }

    StyledText {
        anchors.left: parent.right
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        text: MemService.memUsage
    }
}