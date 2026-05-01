import QtQuick
import Quickshell.Io

Text {
    id: sunset

    text: "󱩷"
    color: root.fg
    font.pixelSize: root.iconSize

    Process {
        id: sunsetOnProcess

        command: ["sh", "-c", "hyprsunset -t 4000"]
    }

    Process {
        id: sunsetOffProcess

        command: ["sh", "-c", "pkill hyprsunset"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (sunsetOnProcess.running)
                sunsetOffProcess.running = true;
            else
                sunsetOnProcess.running = true;
        }
    }

}
