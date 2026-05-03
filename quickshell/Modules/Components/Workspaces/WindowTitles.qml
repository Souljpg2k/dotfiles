import "../../Themes"
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: windowTitles

    width: 100
    height: root.height

    Text {
        property int wsId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1

        anchors.centerIn: parent
        text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.appId : "Workspace " + wsId
        color: Theme.fg
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        width: parent.width
        elide: Text.ElideRight
    }

}
