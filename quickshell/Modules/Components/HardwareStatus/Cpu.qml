import QtQuick
import Quickshell.Io

Item {
    id: ring

    property int value: 0
    property int lastTotal: 0
    property int lastIdle: 0

    width: root.systemSize
    height: root.systemSize

    Text {
        id: cpu

        anchors.centerIn: parent
        text: ""
        color: root.systemColor
        font.pixelSize: root.iconSySize
    }

    Process {
        id: cpuProcess

        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: function(data) {
                if (!data)
                    return ;

                var p = data.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = 0;
                for (var i = 1; i <= 7; i++) total += parseInt(p[i])
                if (ring.lastTotal > 0)
                    ring.value = Math.round(100 * (1 - (idle - ring.lastIdle) / (total - ring.lastTotal)));

                ring.lastTotal = total;
                ring.lastIdle = idle;
            }
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!cpuProcess.running)
                cpuProcess.running = true;

        }
    }

    RingCanvas {
        id: canvas
    }

}
