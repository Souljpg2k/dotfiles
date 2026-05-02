import "../Themes"
import QtQuick
import Quickshell

Item {
    width: 100
    height: 100

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "dddd MM/dd  HH:mm")
        color: Theme.fg
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
    }

}
