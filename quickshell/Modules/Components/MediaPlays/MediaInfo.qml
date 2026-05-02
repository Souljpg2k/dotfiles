import QtQuick
import Quickshell.Io

Item {
    id: mediaInfo

    property string artist: ""
    property string title: ""

    width: 120
    height: root.height - 15

    Text {
        width: 125
        text: mediaInfo.artist ? mediaInfo.artist + " - " + mediaInfo.title : mediaInfo.title || "No media"
        color: root.fg
        font.pixelSize: root.fontSize
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

        Process {
            id: volumeUpProcess

            command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+"]
        }

        Process {
            id: volumeDownProcess

            command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
        }

    }

  Process {
    id: mediaProcess
    command: ["playerctl", "metadata", "--format", "{{artist}} - {{title}}"]

    stdout: SplitParser {
        onRead: function(data) {
            var trimmed = data.trim()
            if (!trimmed) return
            var idx = trimmed.indexOf(" - ")
            if (idx !== -1) {
                mediaInfo.artist = trimmed.substring(0, idx)
                mediaInfo.title = trimmed.substring(idx + 3)
            } else {
                mediaInfo.title = trimmed
            }
        }
    }

    stderr: SplitParser {
        onRead: function(data) {
            mediaInfo.artist = ""
            mediaInfo.title = ""
        }
    }

    onExited: function(code, status) {
        if (code !== 0) {
            mediaInfo.artist = ""
            mediaInfo.title = ""
        }
    }
}

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!mediaProcess.running)
                mediaProcess.running = true;

        }
    }

}