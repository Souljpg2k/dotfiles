import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris

Item {
    id: playPauseBtn

    property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    property bool isPlaying: player ? player.isPlaying : false
    property real progress: 0

    width: root.systemSize
    height: root.systemSize

    Text {
        anchors.centerIn: parent
        text: playPauseBtn.isPlaying ? "󰏤" : "󰐊"
        color: root.fg
        font.pixelSize: root.iconSySize
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (playPauseBtn.player)
                playPauseBtn.player.togglePlaying();

        }
        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                volumeUpProcess.running = true;
            else
                volumeDownProcess.running = true;
        }
    }

    Process {
        id: volumeUpProcess

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]
    }

    Process {
        id: volumeDownProcess

        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
    }

    Connections {
        function onValuesChanged() {
            if (Mpris.players.values.length === 0) {
                playPauseBtn.progress = 0;
                playPauseBtn.player = null;
            } else {
                playPauseBtn.player = Mpris.players.values[0];
            }
        }

        target: Mpris.players
    }

    Connections {
        function onTrackChanged() {
            playPauseBtn.progress = 0;
            canvas.requestPaint();
        }

        target: playPauseBtn.player
    }

    Timer {
        interval: 1000
        running: playPauseBtn.isPlaying
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (playPauseBtn.player && playPauseBtn.player.length > 0) {
                playPauseBtn.player.positionChanged();
                playPauseBtn.progress = Math.min(playPauseBtn.player.position / playPauseBtn.player.length, 1);
            }
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
