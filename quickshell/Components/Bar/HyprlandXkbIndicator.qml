import qs.Components
import qs.Services
import QtQuick
import Quickshell

StyledText {
    text: LayoutService.currentLayout
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
    }
}