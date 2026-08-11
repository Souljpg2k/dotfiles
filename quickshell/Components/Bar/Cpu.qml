import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick

StyledItem {
    Rectangle {
        id: cpuRect
        width: parent.width
        height: parent.height
        radius: Appearance.radius
        color: Appearance.surface_container_high

        CircleProgress { progress: CpuService.cpuUsage / 100 }

        MaterialIcon {
            anchors.centerIn: parent
            text: "earthquake"
            font.family: "Material Symbols Outlined"
        }
    }

    StyledText {
        anchors.left: parent.right
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        text: CpuService.cpuUsage
    }
}