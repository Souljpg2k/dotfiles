import QtQuick
import Quickshell.Io

Item {
    id: ring

    property int value: 0
    property bool showPercent: false
    property int iconSySize: 11

    width: root.systemSize
    height: root.systemSize

    Text {
        id: mem

        anchors.centerIn: parent
        text: ""
        color: root.systemColor
        font.pixelSize: ring.iconSySize
    }

    Text {
        anchors.top: canvas.bottom
        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.topMargin: 2
        text: "Mem  " + ring.value + "%"
        color: root.fg
        font.pixelSize: 10
        font.bold: true
        visible: ring.showPercent
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

    Canvas {
        id: canvas

        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            var cx = width / 2, cy = height / 2;
            var r = width / 2 - 3;
            var start = -Math.PI / 2;
            var end = start + (2 * Math.PI * ring.value / 100);
            ctx.beginPath();
            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
            ctx.strokeStyle = root.lineColor;
            ctx.lineWidth = 2;
            ctx.stroke();
            if (ring.value > 0) {
                ctx.beginPath();
                ctx.arc(cx, cy, r, start, end);
                ctx.strokeStyle = root.fg;
                ctx.lineWidth = 2;
                ctx.lineCap = "round";
                ctx.stroke();
            }
        }

        Connections {
            function onValueChanged() {
                canvas.requestPaint();
            }

            target: ring
        }

    }

}
