import "../../Themes"
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: activeWindow

    width: 150
    height: root.height

    Column {
        anchors.centerIn: parent
        width: parent.width
        spacing: -5

        Text {
            width: parent.width
            text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.appId : ""
            color: Theme.subtext
            font.pixelSize: Theme.fontSize - 2
            elide: Text.ElideRight
            visible: text !== ""
        }

        Text {
            width: parent.width
            text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : "Workspace " + (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1)
            color: Theme.fg
            font.pixelSize: Theme.fontSize
            elide: Text.ElideRight
        }

    }

}
