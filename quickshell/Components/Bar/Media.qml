import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    width: 200
    height: parent.height
    clip: true

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        
        spacing: 8
        z: 1

        Rectangle {
            id: controlButton
            width: Appearance.base + 8
            height: Appearance.base + 8
            radius: Appearance.radius
            color: Appearance.surface_container_high

            CircleProgress { progress: MprisService.progress }

            MaterialIcon {
                anchors.centerIn: parent
                text: MprisService.playPauseIcon
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: MprisService.player?.length ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: MprisService.player?.canTogglePlaying && MprisService.player.togglePlaying()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                id: trackInfo
                anchors.fill: parent
                spacing: 4
                visible: MprisService.hasMedia

                StyledText { text: MprisService.artist }
                StyledText { text: MprisService.separator }
                StyledText {
                    text: MprisService.title
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: "No media"
                visible: !MprisService.hasMedia
            }
        }
    }

    Process {
        id: pavucontrol
        command: ["pavucontrol"]
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        function volumeUp() {
            Quickshell.execDetached(["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "5%+"])
        }

        function volumeDown() {
            Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"])
        }

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) volumeUp()
            else volumeDown()
        }

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                GlobalStates.mediaVisible = !GlobalStates.mediaVisible
            } else if (!pavucontrol.running) {
                pavucontrol.running = true
            }
        }
    }
}