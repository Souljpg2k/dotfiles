import qs.Appearance
import qs.Components
import qs.Services
import qs.Components.Clock
import QtQuick
import QtQuick.Effects
import Quickshell

Item {
    id: root
    anchors.fill: parent

    required property LockContext context
    
    // Background
    Image {
        anchors.fill: parent
        source: WallpaperService.wallpaperPath
        fillMode: Image.PreserveAspectCrop

        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            autoPaddingEnabled: false
            blurMultiplier: 0.1
            blurMax: 64
            blur: 0.6
        }
    }
    
    // Overlay
    Rectangle {
        anchors.fill: parent
        color: Appearance.shadow
        opacity: 0.3
    }

    ClockWidget {
        anchors.centerIn: parent
        scale: 0
        opacity: 0
        rotation: - 180

        Behavior on scale {
            NumberAnimation {
                duration: 600
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
        Behavior on rotation {
            NumberAnimation {
                duration: 600
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }

        Component.onCompleted: {
            scale = 1
            opacity = 1
            rotation = 0
        }
    }

    LockInterface {
        context: root.context
    }
}