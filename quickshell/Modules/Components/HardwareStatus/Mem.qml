import QtQuick
import Quickshell.Io

Item {
    id: ring

    property int value: 0

    width: root.systemSize
    height: root.systemSize

    Text {
        id: mem

        anchors.centerIn: parent
        text: ""
        color: root.systemColor
        font.pixelSize: root.iconSySize
    }

    Process {
        id: memProcess

        command: ["sh", "-c", "free | grep Mem"]

        stdout: SplitParser {
            onRead: function(data) {
                if (!data)
                    return ;

                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                ring.value = Math.round(100 * used / total);
            }
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!memProcess.running)
                memProcess.running = true;

        }
    }

    RingCanvas {
        id: canvas
    }

}
