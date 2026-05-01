import QtQuick
import Quickshell
import Quickshell.Io

Item {
    width: 100
    height: root.height

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "dddd MM/dd  HH:mm")
        color: root.fg
        font.pixelSize: root.fontSize
        font.family: root.fontFamily
    }

}
