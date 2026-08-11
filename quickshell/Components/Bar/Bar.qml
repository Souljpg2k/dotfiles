import qs.Appearance
import qs.Components
import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root

    readonly property int sideMargin: Appearance.base + 10
    readonly property int spacing: 5

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 40
    color: "transparent"

    Rectangle {
        id: bar
        anchors.fill: parent
        height: parent.height
        color: Appearance.background

        RowLayout {
            id: left
            anchors {
                left: parent.left
                leftMargin: sideMargin
            }
            height: parent.height
            spacing: root.spacing

            AppSearch {}
            ActiveWindow {}
        }

        Row {
            id: center
            anchors.centerIn: parent
            width: 980
            height: parent.height
            spacing: root.spacing

            RowLayout {
                height: parent.height
                spacing: root.spacing

                StyledRect {
                    width: 120

                    RowLayout {
                        anchors.fill: parent

                        Mem { Layout.leftMargin: 5 }
                        Cpu { Layout.rightMargin: 5 }
                    }
                }

                StyledRect {
                    width: 200

                    Media {}
                }
                StyledRect {
                    width: 280

                    Workspaces {}
                }
            }

            Item {
                width: 280
                height: parent.height

                RowLayout {
                    anchors.fill: parent
                    spacing: root.spacing

                    StyledRect {
                        width: 150

                        DateTime {
                            anchors.centerIn: parent
                        }
                    }
                    StyledRect {
                        width: 100
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: root.spacing - 5

                            Hyprshot {}
                            HyprPicker {}
                            Hyprsunset {}
                            DarkMode {}
                        }
                    }

                    StyledRect {
                        width: 60

                        WeatherButton {
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }

        RowLayout {
            id: right
            anchors {
                right: parent.right
                rightMargin: sideMargin
            }
            height: parent.height
            spacing: root.spacing

            HyprlandXkbIndicator {}
            PowerButton {}
        }
        MediaPopup {}
    }
}
