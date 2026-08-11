pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property int volumeText: sink?.audio ? Math.round(volume * 100) : 0
    readonly property string muteIcon: muted ? "graphic_eq_off" : "graphic_eq"

    PwObjectTracker {
        objects: [sink]
    }
}