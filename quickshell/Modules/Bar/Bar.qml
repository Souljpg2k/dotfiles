import "../Components"
import "../Components/HardwareStatus"
import "../Components/MediaPlays"
import "../Components/Workspaces"
import "../Themes"
import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root

    property int spacings: 5
    property int marginX: 20
    property int radiusS: 20

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
        color: Theme.bg

        RowLayout {
            id: leftLayout

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: root.marginX
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

            Cpu {
            }

            Mem {
            }

            Rectangle {
                width: 160
                height: root.implicitHeight - 9
                color: Theme.onbg
                radius: root.radiusS

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
                width: 200
                height: root.implicitHeight - 9
                color: Theme.onbg
                radius: root.radiusS

                RowLayout {
                    anchors.centerIn: parent

                    Item {
                        width: 5
                    }

                    Clock {
                    }

                    Item {
                        width: 10
                    }

                    Screenshot {
                    }

                    Wallpaper {
                    }

                    SunSet {
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
            anchors.rightMargin: root.marginX

            PowerMenu {
            }

        }

    }

}
