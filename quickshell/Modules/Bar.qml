import "./Components"
import "./Components/HardwareStatus"
import "./Components/MediaPlays"
import "./Components/Workspaces"
import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root

    property color bg: "#222223"
    property color fg: "#f2f2f7"
    property color onbg: "#2a2a2c"
    property color systemColor: "#8d8d92"
    property color lineColor: "#454546"
    property color pillColor: "#4b4b4b"
    property color wsColor: "#aaaaaa"
    property string fontFamily: "Noto Sans"
    property int fontSize: 12
    property int iconSize: 14
    property int systemSize: 26
    property int spacings: 6
    property int cpuUsage: 0
    property int memUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    color: "transparent"
    implicitHeight: 35

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        id: bar

        anchors.fill: parent
        height: root.height
        color: root.bg
        radius: 20

        anchors {
            topMargin: 5
            leftMargin: 5
            rightMargin: 5
        }

        RowLayout {
            id: leftLayout

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 15
            spacing: root.spacings

            AppLauncher {
            }

            WindowTitles {
            }

        }

        RowLayout {
            id: centerLayout

            anchors.centerIn: parent
            spacing: root.spacings

            Rectangle {
                width: 165
                height: root.height - 9
                color: root.onbg
                radius: 20

                RowLayout {
                    anchors.centerIn: parent
                    spacing: root.spacings

                    MediaPlay {
                    }

                    MediaInfo {
                    }

                }

            }

            Workspaces {
            }

            Rectangle {
                width: 235
                height: root.height - 9
                color: root.onbg
                radius: 20

                RowLayout {
                    anchors.centerIn: parent

                    Item {
                        width: 10
                    }

                    Clock {
                    }

                    Item {
                        width: 10
                    }

                    Cpu {
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: systemStats.isOpen = !systemStats.isOpen
                        }

                    }

                    Gpu {
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: systemStats.isOpen = !systemStats.isOpen
                        }

                    }

                    Mem {
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: systemStats.isOpen = !systemStats.isOpen
                        }

                    }

                }

            }

            Item {
                width: 10
            }

        }

        RowLayout {
            id: rightLayout

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: root.spacings
            anchors.rightMargin: 15

            Screenshot {
            }

            Wallpaper {
            }

            SunSet {
            }

            Item {
                Layout.fillWidth: true
                width: 20
            }

            PowerMenu {
            }

        }

    }

    PopupWindow {
        id: systemStats

        property bool isOpen: false
        property int itemSize: 50
        property int iconSize: 22

        anchor.window: root
        anchor.rect.x: root.width / 1.6 - implicitWidth / 20
        anchor.rect.y: root.height - 0
        implicitWidth: 250
        implicitHeight: isOpen ? 80 : 0
        color: "transparent"
        visible: implicitHeight > 0

        Rectangle {
            anchors.fill: parent
            bottomLeftRadius: 20
            bottomRightRadius: 20
            color: root.bg

            RowLayout {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -10
                spacing: 20

                Cpu {
                    width: systemStats.itemSize
                    height: systemStats.itemSize
                    showPercent: true
                    iconSySize: systemStats.iconSize
                }

                Gpu {
                    width: systemStats.itemSize
                    height: systemStats.itemSize
                    showPercent: true
                    iconSySize: systemStats.iconSize
                }

                Mem {
                    width: systemStats.itemSize
                    height: systemStats.itemSize
                    showPercent: true
                    iconSySize: systemStats.iconSize
                }

            }

        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }

        }

    }

}
