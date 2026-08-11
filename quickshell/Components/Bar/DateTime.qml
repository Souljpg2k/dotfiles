import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick

Item {
    anchors.fill: parent

    Row {
        anchors.centerIn: parent
        spacing: 5

        StyledText {
            text: DateTimeService.time
        }

        StyledText {
            text: "•"
        }

        StyledText {
            text: DateTimeService.date
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: GlobalStates.clockVisible = !GlobalStates.clockVisible
    }   
}