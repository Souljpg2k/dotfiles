import qs
import qs.Appearance
import qs.Components
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Variants {
    id: root

    readonly property int buttonWidth: 130
    readonly property int buttonHeight: 120
    readonly property int buttonSpacing: 8
    readonly property int menuMargin: 24
    readonly property int iconSize: 76

    property color buttonColor: Appearance.background
    property color buttonActiveColor: Appearance.primary
    property color iconColor: Appearance.on_surface
    property color iconActiveColor: Appearance.on_primary

    property list<Button> buttons: [
        Button {
            command: "loginctl lock-session"
            keybind: Qt.Key_K
            icon: "lock"
        },
        Button {
            command: "systemctl hibernate"
            keybind: Qt.Key_H
            icon: "hotel"
        },
        Button {
            command: "systemctl suspend"
            keybind: Qt.Key_U
            icon: "bedtime"
        },
        Button {
            command: "hyprshutdown -t 'Logging out...' --post-cmd 'hyprctl dispatch exit'"
            keybind: Qt.Key_E
            icon: "logout"
        },
        Button {
            command: "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'"
            keybind: Qt.Key_S
            icon: "power_settings_new"
        },
        Button {
            command: "hyprshutdown -t 'Restarting...' --post-cmd 'reboot'"
            keybind: Qt.Key_R
            icon: "restart_alt"
        }
    ]

    model: Quickshell.screens
    
    PanelWindow {
        id: w

        property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"
        visible: GlobalStates.powerMenuVisible || openState > 0.01

        property int focusIndex: 0
        property real openState: GlobalStates.powerMenuVisible ? 1.0 : 0.0
        property bool instantHide: false

        readonly property int actionCount: root.buttons.length
        readonly property real actionSpace: width - root.menuMargin * 2 - root.buttonSpacing * (actionCount - 1)
        readonly property real buttonScale: actionCount > 0 ? Math.min(1.0, Math.max(0.70, actionSpace / (root.buttonWidth * actionCount))) : 1.0
        readonly property int actionWidth: Math.round(root.buttonWidth * buttonScale)
        readonly property int actionHeight: Math.round(root.buttonHeight * buttonScale)

        function closeMenu() {
            GlobalStates.powerMenuVisible = false
        }

        function moveFocus(step) {
            if (actionCount > 0)
            focusIndex = (focusIndex + step + actionCount) % actionCount
        }

        function runAction(action) {
            if (!action) return
            instantHide = true
            action.exec()
        }

        function runFocusedAction() {
            if (focusIndex >= 0 && focusIndex < actionCount)
            runAction(root.buttons[focusIndex])
        }

        function runKeybind(key) {
            for (let i = 0; i < actionCount; i++) {
                if (root.buttons[i].keybind === key) {
                    focusIndex = i
                    runAction(root.buttons[i])
                    return true
                }
            }
            return false
        }

        Behavior on openState {
            enabled: !w.instantHide
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutExpo
            }
        }

        onOpenStateChanged: {
            if (openState <= 0.0)
            w.instantHide = false
        }

        onVisibleChanged: {
            if (visible) contentItem.forceActiveFocus()
        }

        HyprlandFocusGrab {
            windows: [w]
            active: GlobalStates.powerMenuVisible
            onCleared: w.closeMenu()
        }

        contentItem.focus: true
        contentItem.Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                w.closeMenu()
            } else if (event.key === Qt.Key_Left) {
                w.moveFocus(-1)
            } else if (event.key === Qt.Key_Right) {
                w.moveFocus(1)
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                w.runFocusedAction()
            } else {
                event.accepted = w.runKeybind(event.key)
                return
            }
            event.accepted = true
        }

        Item {
            anchors.fill: parent
            opacity: w.openState

            MouseArea {
                anchors.fill: parent
                enabled: w.openState > 0.01
                onClicked: w.closeMenu()
            }

            StyledShadow {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: (1.0 - w.openState) * (parent.width / 2)
                anchors.verticalCenter: parent.verticalCenter

                width: w.actionCount * w.actionWidth + (w.actionCount - 1) * root.buttonSpacing
                height: w.actionHeight
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    spacing: root.buttonSpacing

                    Repeater {
                        model: root.buttons

                        delegate: Rectangle {
                            required property Button modelData
                            required property int index

                            implicitWidth: w.actionWidth
                            implicitHeight: w.actionHeight
                            radius: Appearance.radius + 4

                            readonly property bool isActive: w.focusIndex === index || mouseArea.containsMouse

                            color: isActive ? root.buttonActiveColor : root.buttonColor

                            Behavior on color { 
                                ColorAnimation { 
                                    duration: 120 
                                } 
                            }

                            Behavior on scale { 
                                NumberAnimation { 
                                    duration: 100
                                    easing.type: Easing.OutQuad 
                                } 
                            }

                            scale: mouseArea.pressed ? 0.93 : 1.0

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onEntered: w.focusIndex = index
                                onClicked: w.runAction(modelData)
                            }

                            MaterialIcon {
                                anchors.centerIn: parent
                                text: modelData.icon
                                color: parent.isActive ? root.iconActiveColor : root.iconColor
                                font.pixelSize: root.iconSize
                                scale: parent.isActive ? 1.0 : 0.72

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 250
                                        easing.type: Easing.OutQuad
                                    }
                                }
                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 250
                                        easing.type: Easing.OutQuad
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}