import qs.Appearance
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property string placement: ""
    property bool fillsBarGap: false
    property color surfaceColor: Appearance.background

    readonly property int cornerSize: 26
    readonly property bool anchorsLeft: placement === "BottomLeft" || placement === "TopLeft"
    readonly property bool anchorsBottom: placement === "BottomLeft" || placement === "BottomRight"
    readonly property color fillColor: fillsBarGap ? Appearance.shadow : surfaceColor

    anchors {
        bottom: anchorsBottom
        top: !anchorsBottom
        left: anchorsLeft
        right: !anchorsLeft
    }

    color: "transparent"
    implicitWidth: cornerSize
    implicitHeight: cornerSize
    exclusionMode: fillsBarGap ? ExclusionMode.Ignore : ExclusionMode.Auto
    WlrLayershell.layer: WlrLayer.Top

    Shape {
        width: cornerSize
        height: cornerSize
        layer.enabled: true
        layer.samples: 4

        ShapePath {
            fillColor: root.fillColor
            strokeColor: "transparent"
            startX: anchorsLeft ? 0 : cornerSize
            startY: anchorsBottom ? cornerSize : 0

            PathLine {
                x: anchorsLeft ? cornerSize : 0
                y: anchorsBottom ? cornerSize : 0
            }

            PathQuad {
                x: anchorsLeft ? 0 : cornerSize
                y: anchorsBottom ? 0 : cornerSize
                controlX: anchorsLeft ? 0 : cornerSize
                controlY: anchorsBottom ? cornerSize : 0
            }

            PathLine {
                x: anchorsLeft ? 0 : cornerSize
                y: anchorsBottom ? cornerSize : 0
            }
        }
    }
}