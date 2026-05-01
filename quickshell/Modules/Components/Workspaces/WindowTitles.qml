import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: windowTitles

    width: 200
    height: root.height

    Text {
        property int wsId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1

        anchors.centerIn: parent
        text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.appId : "Workspace  " + wsId
        color: root.fg
        font.pixelSize: fontSize
        font.family: root.fontFamily
        width: windowTitles.width
        elide: Text.ElideRight
    }

}
