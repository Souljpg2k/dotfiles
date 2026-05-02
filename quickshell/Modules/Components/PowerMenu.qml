import "../Themes"
import QtQuick
import Quickshell.Io

Text {
    id: powerMenu

    text: ""
    color: Theme.fg
    font.pixelSize: Theme.iconSize

    Process {
        id: powerMenuProcess

        command: ["sh", "-c", "wlogout -b 6"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: powerMenuProcess.running = true
    }

}
