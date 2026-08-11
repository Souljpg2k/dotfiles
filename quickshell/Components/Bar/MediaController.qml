import qs.Appearance
import qs.Services
import qs.Components
import QtQuick
import Quickshell.Widgets
import Quickshell.Services.Mpris

StyledShadow {
    id: root
    anchors.fill: parent

    readonly property int artSize: 65
    readonly property int seekBarWidth: 240
    readonly property int trackTextWidth: 130
    readonly property int controlBtnSize: 28

    component CtrlBtn: Rectangle {
        property string icon
        property bool active: false
        property var action
        property color iconColor: active ? Appearance.on_background : Appearance.surface_variant

        width: root.controlBtnSize
        height: root.controlBtnSize
        radius: Appearance.radius
        color: "transparent"

        MaterialIcon {
            anchors.centerIn: parent
            text: parent.icon
            color: parent.iconColor
        }

        MouseArea {
            anchors.fill: parent
            enabled: parent.active
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: parent.action?.()
        }
    }

    // volume
    Row {
        id: volumeDisplay
        anchors {
            top: parent.top
            right: parent.right
            margins: 8
            rightMargin: - 2
        }
        spacing: 5
        opacity: 0.6

        MaterialIcon {
            text: AudioService.muteIcon
            font.pixelSize: Appearance.base - 3
            width: 10
        }

        StyledText {
            text: AudioService.volumeText
            font.pixelSize: Appearance.base - 3
            width: 30
        }
    }

    // artwork, trackInfo, seekbar, controls
    Column {
        id: content
        anchors.centerIn: parent
        spacing: 10

        Row {
            id: trackHeader
            spacing: 10

            ClippingWrapperRectangle {
                id: artwork
                width: artSize
                height: artSize
                radius: 12
                color: Appearance.surface_container_high

                Image {
                    anchors.fill: parent
                    source: MprisService.artUrl
                    fillMode: Image.PreserveAspectCrop
                    visible: status === Image.Ready
                }
            }

            Column {
                id: trackInfo
                anchors.verticalCenter: parent.verticalCenter
                spacing: -2

                StyledText {
                    text: MprisService.artist
                    width: root.trackTextWidth
                    elide: Text.ElideRight
                    font.pixelSize: Appearance.base - 2
                }
                StyledText {
                    text: MprisService.title
                    bottomPadding: 5
                    width: root.trackTextWidth
                    elide: Text.ElideRight
                }

                Row {
                    id: time
                    spacing: 5

                    StyledText {
                        text: MprisService.formatSec(MprisService.position)
                        font.pixelSize: Appearance.base - 3
                        width: 35
                    }

                    StyledText {
                        text: "/"
                        font.pixelSize: Appearance.base - 3
                    }

                    StyledText {
                        text: MprisService.formatSec(MprisService.length)
                        font.pixelSize: Appearance.base - 3
                        width: 35
                    }
                }
            }
        }

        Column {
            id: seek
            width: seekBarWidth
            spacing: 4

            property bool isSeeking: false
            property real seekRatio: 0

            Item {
                id: seekBar
                width: parent.width
                height: 8

                Rectangle {
                    id: seekTrack
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 4
                    radius: 4
                    color: Appearance.surface_variant
                    opacity: 0.5

                    Rectangle {
                        width: (seek.isSeeking ? seek.seekRatio : MprisService.progress) * parent.width
                        height: parent.height
                        radius: parent.radius
                        color: Appearance.on_background
                        opacity: 0.9

                        Behavior on width {
                            enabled: !seek.isSeeking
                            SmoothedAnimation { duration: 200 }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: MprisService.canSeek && MprisService.length > 0
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

                    onPressed: mouse => {
                        seek.isSeeking = true
                        MprisService.seeking = true
                        updateRatio(mouse)
                    }

                    onPositionChanged: mouse => {
                        if (pressed)
                            updateRatio(mouse)
                    }

                    onReleased: mouse => {
                        updateRatio(mouse)
                        MprisService.seekTo(seek.seekRatio)
                        MprisService.seeking = false
                        seekReleaseTimer.restart()
                    }

                    onCanceled: {
                        MprisService.seeking = false
                        seek.isSeeking = false
                    }

                    function updateRatio(mouse) {
                        if (seekTrack.width <= 0)
                            return
                        seek.seekRatio = Math.max(0, Math.min(mouse.x / seekTrack.width, 1))
                    }
                }
            }

            Timer {
                id: seekReleaseTimer
                interval: 400
                repeat: false
                onTriggered: seek.isSeeking = false
            }
        }

        Row {
            id: controls
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            CtrlBtn {
                icon: MprisService.shuffleIcon
                active: MprisService.shuffleSupported
                iconColor: MprisService.shuffle && MprisService.shuffleSupported
                ? Appearance.primary
                : MprisService.shuffleSupported ? Appearance.on_background : Appearance.surface_variant
                action: () => MprisService.toggleShuffle()
            }

            CtrlBtn {
                icon: MprisService.previousIcon
                active: MprisService.canGoPrevious
                action: () => MprisService.player?.previous()
            }

            CtrlBtn {
                icon: MprisService.playPauseIcon
                active: MprisService.canTogglePlaying
                color: Appearance.surface_container_high
                action: () => MprisService.player?.togglePlaying()
            }

            CtrlBtn {
                icon: MprisService.nextIcon
                active: MprisService.canGoNext
                action: () => MprisService.player?.next()
            }

            CtrlBtn {
                icon: MprisService.loopIcon
                active: MprisService.loopSupported
                iconColor: MprisService.loopState !== MprisLoopState.None && MprisService.loopSupported
                ? Appearance.primary
                : MprisService.loopSupported ? Appearance.on_background : Appearance.surface_variant
                action: () => MprisService.cycleLoop()
            }
        }
    }
}