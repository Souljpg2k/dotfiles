import QtQuick
import Quickshell.Io

Item {
    id: playPauseBtn

    property bool isPlaying: false
    property real progress: 0

    width: root.systemSize
    height: root.systemSize

    Text {
        anchors.centerIn: parent
        text: playPauseBtn.isPlaying ? "󰏤" : "󰐊"
        color: root.fg
        font.pixelSize: 11
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!playPauseProcess.running)
                playPauseProcess.running = true;

            refreshTimer.restart();
        }
        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                volumeUpProcess.running = true;
            else
                volumeDownProcess.running = true;
        }
    }

    Process {
        id: playPauseProcess

        command: ["playerctl", "play-pause"]
        onExited: refreshTimer.restart()
    }

    Process {
        id: volumeUpProcess

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]
    }

    Process {
        id: volumeDownProcess

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
    }

    Process {
        id: statusProcess

        command: ["playerctl", "metadata", "--format", "{{status}}|{{position}}|{{mpris:length}}"]
        onExited: function(code, status) {
            if (code !== 0) {
                playPauseBtn.isPlaying = false;
                playPauseBtn.progress = 0;
            }
        }

        stdout: SplitParser {
            onRead: function(data) {
                var parts = data.trim().split("|");
                if (parts.length < 3)
                    return ;

                var newPlaying = parts[0] === "Playing";
                var pos = parseFloat(parts[1]) || 0;
                var len = parseFloat(parts[2]) || 1;
                var newProgress = len > 0 ? pos / len : 0;
                if (newProgress < 0.01 && playPauseBtn.progress > 0.05)
                    playPauseBtn.progress = 0;

                playPauseBtn.isPlaying = newPlaying;
                playPauseBtn.progress = newProgress;
            }
        }

        stderr: SplitParser {
            onRead: function(data) {
                playPauseBtn.isPlaying = false;
                playPauseBtn.progress = 0;
            }
        }

    }

    Timer {
        id: refreshTimer

        interval: 300
        onTriggered: {
            if (!statusProcess.running)
                statusProcess.running = true;

        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!statusProcess.running)
                statusProcess.running = true;

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
            ctx.beginPath();
            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
            ctx.strokeStyle = root.lineColor;
            ctx.lineWidth = 2;
            ctx.stroke();
            if (playPauseBtn.progress > 0) {
                var start = -Math.PI / 2;
                var end = start + (2 * Math.PI * playPauseBtn.progress);
                ctx.beginPath();
                ctx.arc(cx, cy, r, start, end);
                ctx.strokeStyle = root.fg;
                ctx.lineWidth = 2;
                ctx.lineCap = "round";
                ctx.stroke();
            }
        }

        Connections {
            function onProgressChanged() {
                canvas.requestPaint();
            }

            function onIsPlayingChanged() {
                canvas.requestPaint();
            }

            target: playPauseBtn
        }

    }

}
