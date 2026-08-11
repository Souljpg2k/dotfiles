import qs.Components
import QtQuick
import Quickshell

StyledItem {
    StyledText {
        anchors.centerIn: parent
        text: "󰣇"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])
    }
}