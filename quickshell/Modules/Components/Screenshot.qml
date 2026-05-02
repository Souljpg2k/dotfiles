import "../Themes"
import QtQuick
import Quickshell.Io

Text {
    id: screenshot

    text: "󱈀"
    color: Theme.fg
    font.pixelSize: Theme.iconSize

    Process {
        id: hyprshotRegionProcess

        command: ["sh", "-c", "hyprshot -m region -o ~/Screenshots"]
    }

    Process {
        id: hyprshotWindowProcess

        command: ["sh", "-c", "hyprshot -m window -o ~/Screenshots"]
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton)
                hyprshotRegionProcess.running = true;
            else if (mouse.button === Qt.RightButton)
                hyprshotWindowProcess.running = true;
        }
    }

}
