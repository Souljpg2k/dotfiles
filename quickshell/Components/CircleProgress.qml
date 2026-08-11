import qs.Appearance
import QtQuick

Canvas {
    anchors.fill: parent
    opacity: 0.3

    property real progress: 0

    Behavior on progress {
        NumberAnimation { 
            duration: 500
            easing.type: Easing.OutCubic
        }
    }

    onProgressChanged: requestPaint()
    onPaint: {
        const ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        ctx.beginPath()
        ctx.moveTo(width / 2, height / 2)
        ctx.arc(width / 2, height / 2, Math.min(width, height) / 2, -Math.PI / 2, (-Math.PI / 2) + progress * 2 * Math.PI)
        ctx.closePath()
        ctx.fillStyle = Appearance.primary
        ctx.fill()
    }
}