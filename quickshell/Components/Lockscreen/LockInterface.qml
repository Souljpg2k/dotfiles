import qs.Appearance
import qs.Services
import qs.Components
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Item {
    id: root

    required property LockContext context

    property ListModel dotModel: ListModel {}

    readonly property list<string> iconPool: ["󰮯", "", "", "󰽢"]
    readonly property string iconFont: "JetBrainsMono Nerd Font"
    readonly property int iconSize: 14
    readonly property int panelHeight: 40

    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: 15
    }

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    function syncDots(length: int): void {
        while (dotModel.count > length)
            dotModel.remove(dotModel.count - 1)

        while (dotModel.count < length) {
            const icon = iconPool[Math.floor(Math.random() * iconPool.length)]
            dotModel.append({ "icon": icon })
        }
    }

    // Wrong password flash
    Text {
        id: errorText

        anchors {
            bottom: row.top
            horizontalCenter: row.horizontalCenter
            bottomMargin: 6
        }

        text: "Wrong password"
        font.pixelSize: 12
        color: Appearance.error
        opacity: 0

        Connections {
            target: root.context
            function onFlashMsg() {
                errorText.opacity = 1
                fadeOut.restart()
            }
        }

        NumberAnimation {
            id: fadeOut
            target: errorText
            property: "opacity"
            to: 0
            duration: 2000
            easing.type: Easing.InCubic
        }
    }

    RowLayout {
        id: row
        anchors.bottom: parent.bottom
        spacing: 8

        // User + keyboard layout
        StyledShadow {
            width: 110
            height: root.panelHeight
            radius: Appearance.radius
            color: Appearance.surface_container

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 12
                    rightMargin: 12
                }
                spacing: 4

                MaterialIcon { text: "account_circle" }

                StyledText {
                    text: Quickshell.env("USER") ?? "user"
                }

                Item { Layout.fillWidth: true }

                MaterialIcon { text: "keyboard" }

                StyledText {
                    text: LayoutService.currentLayout
                    Layout.fillWidth: true
                }
            }
        }

        // Password field
        StyledShadow {
            width: 200
            height: root.panelHeight
            radius: Appearance.radius
            color: Appearance.surface_container

            TextField {
                id: passwordBox

                width: 0
                height: 0
                visible: false
                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: {
                    root.context.currentText = text
                    root.syncDots(text.length)
                }

                onAccepted: root.context.tryUnlock()

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        if (passwordBox.text !== root.context.currentText)
                            passwordBox.text = root.context.currentText
                    }
                }
            }

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 17
                    rightMargin: 5
                }
                spacing: 7

                // Placeholder + icon dots + caret
                Item {
                    Layout.fillWidth: true
                    height: parent.height
                    clip: true

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Enter password"
                        font.pixelSize: 14
                        color: Appearance.outline
                        opacity: dotModel.count > 0 ? 0 : 0.7

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 180
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Flickable {
                        id: dotsFlickable
                        anchors.fill: parent
                        contentWidth: dotsRow.implicitWidth
                        contentX: Math.max(contentWidth - width, 0)
                        clip: true
                        interactive: false

                        Behavior on contentX {
                            NumberAnimation {
                                duration: 120
                                easing.type: Easing.OutCubic
                            }
                        }

                        Row {
                            id: dotsRow
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 5

                            Repeater {
                                model: dotModel

                                Item {
                                    width: root.iconSize + 2
                                    height: root.iconSize + 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.icon
                                        font.family: root.iconFont
                                        font.pixelSize: root.iconSize
                                        color: Appearance.on_surface
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        opacity: 0
                                        scale: 0

                                        Behavior on opacity {
                                            NumberAnimation {
                                                duration: 220
                                                easing.type: Easing.OutCubic
                                            }
                                        }

                                        Behavior on scale {
                                            NumberAnimation {
                                                duration: 220
                                                easing.type: Easing.OutBack
                                                easing.overshoot: 1.2
                                            }
                                        }

                                        Component.onCompleted: {
                                            opacity = 1
                                            scale = 1
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: cursor
                        anchors.verticalCenter: parent.verticalCenter
                        x: Math.min(
                            dotsRow.implicitWidth + 2 - dotsFlickable.contentX,
                            parent.width - width - 2
                        )
                        width: 2
                        height: 16
                        color: Appearance.primary
                        visible: passwordBox.activeFocus

                        Behavior on x {
                            NumberAnimation {
                                duration: 120
                                easing.type: Easing.OutCubic
                            }
                        }

                        SequentialAnimation {
                            running: cursor.visible
                            loops: Animation.Infinite

                            NumberAnimation {
                                target: cursor
                                property: "opacity"
                                to: 0
                                duration: 500
                                easing.type: Easing.InOutQuad
                            }

                            NumberAnimation {
                                target: cursor
                                property: "opacity"
                                to: 1
                                duration: 500
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }

                // Submit
                Rectangle {
                    width: 28
                    height: 28
                    radius: Appearance.radius - 2
                    color: Appearance.on_background

                    Text {
                        anchors.centerIn: parent
                        text: "arrow_forward"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 18
                        color: root.context.currentText.length > 0
                            ? Appearance.background
                            : Appearance.outline

                        Behavior on color {
                            ColorAnimation { duration: 250 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: !root.context.unlockInProgress
                        onClicked: root.context.tryUnlock()
                    }
                }
            }
        }

        // Power actions
        StyledShadow {
            width: 110
            height: root.panelHeight
            radius: Appearance.radius
            color: Appearance.surface_container

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 14
                    rightMargin: 12
                }
                spacing: 10

                MaterialIcon {
                    text: "logout"
                    font.bold: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached([
                            "sh", "-c",
                            "hyprshutdown -t 'Logging out...' --post-cmd 'hyprctl dispatch exit'"
                        ])
                    }
                }

                MaterialIcon {
                    text: "power_settings_new"
                    font.bold: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached([
                            "sh", "-c",
                            "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'"
                        ])
                    }
                }

                MaterialIcon {
                    text: "restart_alt"
                    font.bold: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached([
                            "sh", "-c",
                            "hyprshutdown -t 'Restarting...' --post-cmd 'reboot'"
                        ])
                    }
                }
            }
        }
    }
}