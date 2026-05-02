import "../../Themes"
import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris

Item {
    id: mediaInfo

    property var player: {
        for (var i = 0; i < Mpris.players.values.length; i++) {
            var p = Mpris.players.values[i];
            if (p.dbusName !== "org.mpris.MediaPlayer2.playerctld")
                return p;

        }
        return null;
    }

    width: 120
    height: root.height
    Component.onCompleted: {
        if (player) {
            console.log("artist:", player.trackArtist);
            console.log("title:", player.trackTitle);
        }
    }

    Text {
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        text: {
            if (!mediaInfo.player)
                return "No media";

            var artist = mediaInfo.player.trackArtist;
            var title = mediaInfo.player.trackTitle;
            if (artist && title)
                return artist + " - " + title;

            return title || artist || "No media";
        }
        color: Theme.fg
        font.pixelSize: Theme.fontSize
        elide: Text.ElideRight

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
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
