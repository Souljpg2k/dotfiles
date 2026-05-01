import QtQuick
import Quickshell.Io

Item {
    id: ring

    property int value: 0
    property bool showPercent: false
    property int iconSySize: 11

    width: root.systemSize
    height: root.systemSize + (showPercent ? 14 : 0)

    Text {
        id: gpu

        anchors.centerIn: parent
        text: ""
        color: root.systemColor
        font.pixelSize: ring.iconSySize
    }

    Text {
        anchors.top: canvas.bottom
        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.topMargin: 2
        text: "GPU  " + ring.value + "%"
        color: root.fg
        font.pixelSize: 10
        font.bold: true
        visible: ring.showPercent
    }

    Process {
        id: gpuProcess

        command: ["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1 || nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0"]

        stdout: SplitParser {
            onRead: function(data) {
                ring.value = Math.round(parseFloat(data.trim())) || 0;
            }
        }

    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!gpuProcess.running)
                gpuProcess.running = true;

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
