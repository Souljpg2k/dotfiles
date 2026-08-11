import qs
import qs.Components
import QtQuick

StyledItem {
    MaterialIcon {
        anchors.centerIn: parent
        text: "power_settings_new"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: GlobalStates.powerMenuVisible = !GlobalStates.powerMenuVisible
    }
}