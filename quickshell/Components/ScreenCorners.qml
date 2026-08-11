import QtQuick
import Quickshell

Instantiator {
    id: cornerInstantiator

    readonly property var cornerPlacements: [
        { placement: "TopLeft", fillsBarGap: true },
        { placement: "TopRight", fillsBarGap: true },
        { placement: "TopLeft", fillsBarGap: false },
        { placement: "TopRight", fillsBarGap: false },
        { placement: "BottomLeft", fillsBarGap: false },
        { placement: "BottomRight", fillsBarGap: false },
    ]

    model: cornerPlacements

    delegate: ScreenCorner {
        required property var modelData

        placement: modelData.placement
        fillsBarGap: modelData.fillsBarGap
    }
}