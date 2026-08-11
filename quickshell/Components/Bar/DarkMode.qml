import qs.Components
import QtQuick
import Quickshell

StyledItem {
    MaterialIcon {
        anchors.centerIn: parent
        text: "dark_mode"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["sh", "-c", "$HOME/.config/hypr/scripts/dark-mode.sh"])
    }
}