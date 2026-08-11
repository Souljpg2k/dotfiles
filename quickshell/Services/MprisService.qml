pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer trackedPlayer: null
    property bool seeking: false
    property MprisPlayer player: trackedPlayer ?? Mpris.players.values[0] ?? null

    Instantiator {
        model: Mpris.players
        delegate: Connections {
            required property MprisPlayer modelData
            target: modelData

            Component.onCompleted: {
                if (root.trackedPlayer == null || modelData.isPlaying)
                    root.trackedPlayer = modelData
            }

            Component.onDestruction: {
                if (root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
                    for (const p of Mpris.players.values) {
                        if (p.isPlaying) {
                            root.trackedPlayer = p
                            return
                        }
                    }
                    root.trackedPlayer = Mpris.players.values[0] ?? null
                }
            }

            function onPlaybackStateChanged() {
                if (modelData.playbackState === MprisPlaybackState.Playing)
                    root.trackedPlayer = modelData
            }
        }
    }

    readonly property string artist: !player ? "No media" : player.trackArtist || "Unknown Artist"
    readonly property string title: player?.trackTitle || "Unknown Title"
    readonly property string separator: (hasMedia && title) ? " • " : ""
    readonly property string artUrl: player?.trackArtUrl || ("../../Assets/bocchi.jpg")

    readonly property string playPauseIcon: player ? (player.playbackState === MprisPlaybackState.Playing ? "pause" : "play_arrow") : "music_note"
    readonly property string previousIcon: "skip_previous"
    readonly property string nextIcon: "skip_next"

    readonly property real progress: (player && player.lengthSupported && player.length > 0) ? player.position / player.length : 0
    readonly property real position: player?.position ?? 0
    readonly property real length: player?.length ?? 0

    readonly property bool hasMedia: player !== null
    readonly property bool canSeek: player?.canSeek ?? false
    readonly property bool canGoPrevious: player?.canGoPrevious ?? false
    readonly property bool canGoNext: player?.canGoNext ?? false
    readonly property bool canTogglePlaying: player?.canTogglePlaying ?? false

    readonly property bool loopSupported: player?.loopSupported ?? false
    readonly property int loopState: player?.loopState ?? MprisLoopState.None
    readonly property string loopIcon: loopState === MprisLoopState.Track ? "repeat_one" : "repeat"

    readonly property bool shuffleSupported: player?.shuffleSupported ?? false
    readonly property bool shuffle: player?.shuffle ?? false
    readonly property string shuffleIcon: "shuffle"

    function cycleLoop() {
        if (!player || !loopSupported) return
        if (player.loopState === MprisLoopState.None)
            player.loopState = MprisLoopState.Playlist
        else if (player.loopState === MprisLoopState.Playlist)
            player.loopState = MprisLoopState.Track
        else
            player.loopState = MprisLoopState.None
    }

    function toggleShuffle() {
        if (!player || !shuffleSupported) return
            player.shuffle = !player.shuffle
    }

    function seekTo(ratio) {
        const p = player
        if (!p || !p.canSeek)
            return

        const len = p.length
        if (!(len > 0))
            return

        const target = Math.max(0, Math.min(ratio, 1)) * len
        if (p.positionSupported)
            p.position = target
        else
            p.seek(target - p.position)
    }

    function formatSec(s) {
        s = Math.floor(s)
        const m = Math.floor(s / 60)
        return String(m).padStart(2, "0") + ":" + String(s % 60).padStart(2, "0")
    }

    Timer {
        running: root.player?.playbackState === MprisPlaybackState.Playing && !root.seeking
        interval: 1000
        repeat: true
        onTriggered: root.player.positionChanged()
    }
}