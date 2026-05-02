import "../../Themes"
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: windowTitles

    width: 100
    height: 100

    Text {
        property int wsId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1

        anchors.centerIn: parent
        text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.appId : "Workspace  " + wsId
        color: Theme.fg
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        width: windowTitles.width
        elide: Text.ElideRight
    }

}
