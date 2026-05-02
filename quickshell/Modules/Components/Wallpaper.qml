import QtQuick
import Quickshell.Io

Text {
    id: wallpaper

    text: ""
    color: root.fg
    font.pixelSize: root.iconSize

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
