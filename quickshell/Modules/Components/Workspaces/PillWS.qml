import "../../Themes"
import QtQuick

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
    color: Theme.pillColor

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
