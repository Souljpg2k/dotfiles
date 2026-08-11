import qs
import QtQuick
import Quickshell

QtObject {
    required property string command
    required property string icon
    property int keybind: 0

    function exec() {
        GlobalStates.powerMenuVisible = false
        Quickshell.execDetached(["sh", "-c", command])
    }
}