import qs
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Bottom

    visible: GlobalStates.clockVisible || openState > 0.01

    property bool isDragging: false
    property real openState: 0

    Behavior on openState {
        NumberAnimation {
            duration: GlobalStates.clockVisible ? 380 : 260
            easing.type: GlobalStates.clockVisible ? Easing.OutBack : Easing.InCubic
            easing.overshoot: 1.12
        }
    }

    Component.onCompleted: {
        if (GlobalStates.clockVisible)
            Qt.callLater(() => openState = 1)
    }

    Connections {
        target: GlobalStates
        function onClockVisibleChanged() {
            openState = GlobalStates.clockVisible ? 1 : 0
        }
    }

    mask: Region {
        item: maskItem
    }

    Item {
        id: maskItem
        x: isDragging ? 0 : clockItem.x
        y: isDragging ? 0 : clockItem.y
        width: isDragging ? root.width : clockItem.width
        height: isDragging ? root.height : clockItem.height
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.openState > 0.5
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

        property real startX: 0
        property real startY: 0

        onPressed: (mouse) => {
            isDragging = true
            clockItem.x = clockItem.x
            clockItem.y = clockItem.y
            startX = mouse.x
            startY = mouse.y
        }

        onPositionChanged: (mouse) => {
            if (!pressed) return
            var dx = mouse.x - startX
            var dy = mouse.y - startY
            clockItem.x = Math.max(0, Math.min(clockItem.x + dx, root.screen.width - clockItem.width))
            clockItem.y = Math.max(0, Math.min(clockItem.y + dy, root.screen.height - clockItem.height))
            startX = mouse.x
            startY = mouse.y
        }

        onReleased: {
            isDragging = false
            GlobalStates.saveClockPosition(clockItem.x, clockItem.y)
        }
    }

    Item {
        id: clockItem

        width: 150
        height: 150
        x: Math.round(GlobalStates.clockX)
        y: Math.round(GlobalStates.clockY)

        opacity: root.openState
        scale: 0.78 + 0.22 * root.openState
        transformOrigin: Item.Center

        ClockWidget {}
    }
}