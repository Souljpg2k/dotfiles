import qs.Components
import QtQuick
import Quickshell

StyledItem {
    readonly property int nightTemperatureK: 4500
    property bool nightMode: false

    MaterialIcon {
        anchors.centerIn: parent
        text: "light_mode"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            nightMode = !nightMode
            if (nightMode) {
                Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", String(nightTemperatureK)])
            } else {
                Quickshell.execDetached(["hyprctl", "hyprsunset", "identity"])
            }
        }
    }
}