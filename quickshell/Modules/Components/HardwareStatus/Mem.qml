import "../../Themes"
import QtQuick
import Quickshell.Io

Item {
    id: ring

    property int value: 0

    width: Theme.systemSize
    height: Theme.systemSize

    Text {
        id: mem

        anchors.centerIn: parent
        text: ""
        color: Theme.fg
        font.pixelSize: Theme.iconSizes
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
