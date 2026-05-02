import "./Components"
import "./Components/HardwareStatus"
import "./Components/MediaPlays"
import "./Components/Workspaces"
import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root

    property color bg: "#181821"
    property color fg: "#cdd6f4"
    property color onbg: "#232332"
    property color systemColor: "#cdd6f4"
    property color lineColor: "#45475a"
    property color pillColor: "#585b70"
    property color wsColor: "#cdd6f4"
    property string fontFamily: "Noto Sans"
    property int iconSySize: 11
    property int fontSize: 12
    property int iconSize: 14
    property int systemSize: 26
    property int spacings: 6

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

        RowLayout {
            id: leftLayout

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
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
                width: 200
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
            anchors.rightMargin: 20

            Item {
                Layout.fillWidth: true
                width: 20
            }

            PowerMenu {
            }

        }

    }

}
