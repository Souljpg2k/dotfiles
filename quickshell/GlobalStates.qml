pragma Singleton

import Quickshell

Singleton {
    id: root
    
    property bool mediaVisible: false
    property bool powerMenuVisible: false
    property bool screenLocked: false

    signal loaded()

    property alias clockVisible: persist.clockVisible
    property alias clockX: persist.clockX
    property alias clockY: persist.clockY

    function saveClockPosition(x, y) {
        persist.clockX = Math.round(x)
        persist.clockY = Math.round(y)
    }

    PersistentProperties {
        id: persist
        reloadableId: "widgets"

        property real clockX: 600.0
        property real clockY: 140.0
        property bool clockVisible: false

        onLoaded: root.loaded()
    }
}