import qs
import qs.Components.Bar
import QtQuick
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: mediaPopup
    anchor.window: root
    anchor.rect.x: root.width / 2 - width / 2 - 260
    anchor.rect.y: root.height + 2
    
    implicitWidth: 280
    implicitHeight: 160
    color: "transparent"
    
    visible: GlobalStates.mediaVisible || panel.opacity > 0.01

    HyprlandFocusGrab {
        windows: [mediaPopup, root]
        active: GlobalStates.mediaVisible
        onCleared: GlobalStates.mediaVisible = false
    }

    Item {
        id: panel
        width: parent.width - 20
        height: parent.height - 20
        
        property real openPopup: GlobalStates.mediaVisible ? 1 : 0
        
        x: 10
        y: -7 + 12 * openPopup
        opacity: openPopup

        Behavior on openPopup {
            NumberAnimation {
                duration: 220
                easing.type: Easing.InOutCubic
            }
        }

        MediaController {}
    }
}