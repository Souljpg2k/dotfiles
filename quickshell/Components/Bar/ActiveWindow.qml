import qs.Appearance
import qs.Components
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland

StyledItem {
    id: root
    width: Appearance.base + 120

    readonly property var activeWindow: ToplevelManager.activeToplevel
    property string desktopName: "Desktop"

    Column {
        spacing: - 6
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        
        StyledText {
            text: root.activeWindow?.appId ?? root.desktopName
            font.pixelSize: Appearance.base - 3
            font.bold: true
            width: root.width
            elide: Text.ElideRight
            opacity: 0.5
        }

        StyledText {
            text: "workspace " + Hyprland.focusedMonitor?.activeWorkspace?.id ?? ""
            width: root.width 
            elide: Text.ElideRight
        }
    }
}