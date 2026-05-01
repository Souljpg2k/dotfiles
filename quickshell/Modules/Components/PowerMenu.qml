import QtQuick
import Quickshell.Io

Text {
    id: powerMenu

    text: ""
    color: root.fg
    font.pixelSize: root.iconSize

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
