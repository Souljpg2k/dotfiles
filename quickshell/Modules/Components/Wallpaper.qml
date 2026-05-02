import "../Themes"
import QtQuick
import Quickshell.Io

Text {
    id: wallpaper

    text: ""
    color: Theme.fg
    font.pixelSize: Theme.iconSize

    Process {
        id: wallpaperProcess

        command: ["sh", "-c", "$HOME/.config/hypr/scripts/wallpapers.sh"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: wallpaperProcess.running = true
    }

}
