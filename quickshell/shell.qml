import qs.Components
import qs.Components.Bar
import qs.Components.Power
import qs.Components.Clock
import qs.Components.Lockscreen
import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Bar {
                property var modelData
                screen: modelData
            }
        }
    }

    GlobalShortcuts {}
    ScreenCorners {}
    PowerMenu {}

    LockContext {
        id: lockContext
        onUnlocked: GlobalStates.screenLocked = false
    }

    WlSessionLock {
        id: sessionLock
        locked: GlobalStates.screenLocked

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    LazyLoader {
        active: GlobalStates.clockVisible || (item && item.openState > 0.01)
        component: Clock {}
    }
}