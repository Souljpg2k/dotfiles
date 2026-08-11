import Quickshell
import Quickshell.Hyprland

Scope {
    id: root

    GlobalShortcut {
        name: "powermenu"
        description: "toggle powermenu"
        onPressed: GlobalStates.powerMenuVisible = !GlobalStates.powerMenuVisible
    }

    GlobalShortcut {
        name: "mediaController"
        description: "toggle MediaController"
        onPressed: GlobalStates.mediaVisible = !GlobalStates.mediaVisible
    }

    GlobalShortcut {
        name: "clock"
        description: "toggle clock"
        onPressed: GlobalStates.clockVisible = !GlobalStates.clockVisible
    }

    GlobalShortcut {
        name: "lock"
        description: "Lock screen"
        onPressed: GlobalStates.screenLocked = true
    }
}