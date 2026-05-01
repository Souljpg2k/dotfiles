import QtQuick
import Quickshell.Io

Item {
    id: ring

    property int value: 0
    property int lastTotal: 0
    property int lastIdle: 0
    property int iconSySize: 11
    property bool showPercent: false

    width: root.systemSize
    height: root.systemSize

    Text {
        id: cpu

        anchors.centerIn: parent
        text: ""
        color: root.systemColor
        font.pixelSize: ring.iconSySize
    }

    Text {
        anchors.top: canvas.bottom
        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.topMargin: 2
        text: "CPU  " + ring.value + "%"
        color: root.fg
        font.pixelSize: 10
        font.bold: true
        visible: ring.showPercent
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
