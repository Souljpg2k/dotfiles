import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: workspaceBar

    property int wsCount: 10
    property int activeWs: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id - 1 : 0

    function isOccupied(wsIndex) {
        var toplevels = Hyprland.toplevels;
        for (var i = 0; i < toplevels.count; i++) {
            var t = toplevels.values[i];
            if (t.workspace && t.workspace.id === wsIndex + 1)
                return true;

        }
        return false;
    }

    color: root.onbg
    radius: 20
    implicitWidth: row.implicitWidth + 16
    implicitHeight: root.height - 10

    Rectangle {
        id: activePill

        property bool traveling: false
        property int pillW: traveling ? 40 : 24

        x: {
            var baseX = workspaceBar.activeWs * 28 + 8;
            var maxX = workspaceBar.width - pillW - 8;
            return Math.min(baseX, maxX);
        }
        y: (parent.height - height) / 2
        width: pillW
        height: 24
        radius: 50
        color: root.pillColor

        Connections {
            function onActiveWsChanged() {
                activePill.traveling = true;
                travelTimer.restart();
            }

            target: workspaceBar
        }

        Timer {
            id: travelTimer

            interval: 220
            onTriggered: activePill.traveling = false
        }

        Behavior on x {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }

        }

        Behavior on width {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }

        }

    }

    Row {
        id: row

        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: workspaceBar.wsCount

            Item {
                width: 24
                height: 24

                Text {
                    anchors.centerIn: parent
                    text: workspaceBar.activeWs === index ? "󰮯" : (workspaceBar.isOccupied(index) ? "" : "")
                    font.pixelSize: workspaceBar.activeWs === index ? 14 : 10
                    color: workspaceBar.activeWs === index ? root.fg : root.wsColor
                    visible: text !== ""

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }

                    }

                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    onWheel: (wheel) => {
                        var current = Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1;
                        if (wheel.angleDelta.y > 0)
                            Hyprland.dispatch("workspace " + Math.max(1, current - 1));
                        else
                            Hyprland.dispatch("workspace " + Math.min(workspaceBar.wsCount, current + 1));
                    }
                }

            }

        }

    }

}
