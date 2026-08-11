pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string time: Qt.formatDateTime(clock.date, "HH:mm")
    readonly property string hours: Qt.formatDateTime(clock.date, "HH")
    readonly property string minutes: Qt.formatDateTime(clock.date, "mm")
    readonly property string seconds: Qt.formatDateTime(clock.date, "ss")
    readonly property string date: Qt.formatDateTime(clock.date, "ddd, dd/MM")
    readonly property string day: Qt.formatDateTime(clock.date, "dddd")
    readonly property string month: Qt.formatDateTime(clock.date, "MMMM")
    readonly property string ap: Qt.formatDateTime(clock.date, "AP")
    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }   
}