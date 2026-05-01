import QtQuick
import Quickshell.Io

Text {
    id: wallpaper

    text: ""
    color: root.fg
    font.pixelSize: root.iconSize

    Process {
        id: wallpaperOnProcess

        command: ["sh", "-c", "waypaper"]
    }

    Process {
        id: wallpaperOffProcess

        command: ["sh", "-c", "pkill waypaper"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (wallpaperOnProcess.running)
                wallpaperOffProcess.running = true;
            else
                wallpaperOnProcess.running = true;
        }
    }

}
