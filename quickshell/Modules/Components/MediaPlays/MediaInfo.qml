import "../../Themes"
import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris

Item {
    id: mediaInfo

    property var player: null
    readonly property string displayText: {
        if (!player)
            return "No media";

        var title = player.trackTitle || "";
        var artist = player.trackArtist || "";
        if (title && artist)
            return title + " • " + artist;

        return title || artist || "No media";
    }

    width: 120
    height: root.height

    Connections {
        function onValuesChanged() {
            var found = null;
            for (var i = 0; i < Mpris.players.values.length; i++) {
                var p = Mpris.players.values[i];
                if (p.dbusName !== "org.mpris.MediaPlayer2.playerctld") {
                    found = p;
                    break;
                }
            }
            mediaInfo.player = found;
        }

        target: Mpris.players
    }

    Timer {
        running: mediaInfo.player ? mediaInfo.player.playbackState === MprisPlaybackState.Playing : false
        interval: 1000
        repeat: true
        onTriggered: {
            if (mediaInfo.player)
                mediaInfo.player.positionChanged();

        }
    }

    Text {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        text: mediaInfo.displayText
        color: Theme.fg
        font.pixelSize: Theme.fontSize
        elide: Text.ElideRight

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: function(event) {
                if (event.button === Qt.RightButton) {
                    if (mediaInfo.player)
                        mediaInfo.player.next();

                } else if (event.button === Qt.LeftButton) {
                    if (mediaInfo.player)
                        mediaInfo.player.previous();

                }
            }
            onWheel: function(wheel) {
                if (wheel.angleDelta.y > 0)
                    volumeUpProcess.running = true;
                else
                    volumeDownProcess.running = true;
            }
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

}
