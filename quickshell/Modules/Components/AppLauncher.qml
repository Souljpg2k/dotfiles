import QtQuick
import Quickshell.Io

Text {
    id: applauncher

    text: "󰋸"
    color: root.fg
    font.pixelSize: root.iconSize

    Process {
        id: applauncherProcess

        command: ["sh", "-c", "rofi -show drun"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: applauncherProcess.running = true
    }

}
