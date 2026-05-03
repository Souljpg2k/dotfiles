import "../../Themes"
import QtQuick
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

    color: Theme.onbg
    radius: root.radiusS
    implicitWidth: row.implicitWidth + 16
    implicitHeight: root.height - 9

    PillWS {
    }

    Row {
        id: row

        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: workspaceBar.wsCount

            Item {
                property var ws: Hyprland.workspaces.values.find(function(w) {
                    return w.id === index + 1;
                })
                property bool isActive: workspaceBar.activeWs === index

                width: 24
                height: 24

                Text {
                    anchors.centerIn: parent
                    text: isActive ? "󰮯" : (workspaceBar.isOccupied(index) ? "" : index + 1)
                    font.pixelSize: isActive ? 14 : 10
                    color: isActive ? Theme.fg : (ws ? Theme.wsColor : Theme.lineColor)

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
                    onWheel: function(wheel) {
                        var current = Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1;
                        var next;
                        if (wheel.angleDelta.y > 0)
                            next = Math.max(1, current - 1);
                        else
                            next = Math.min(workspaceBar.wsCount, current + 1);
                        if (next !== current)
                            Hyprland.dispatch("workspace " + next);

                    }
                }

            }

        }

    }

}
