import qs.Appearance
import QtQuick
import QtQuick.Effects

Canvas {
    id: canvas
    anchors.fill: parent

    layer.enabled: true
    layer.effect: MultiEffect {
        saturation: - 0.4
    }

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        const cx = width / 2
        const cy = height / 2
        const petals = 8
        const baseRadius = 70
        const waveRadius = 5
        ctx.beginPath()
        
        for (let i = 0; i <= 360; i++) {
            const t = i * Math.PI / 180
            const r = baseRadius + waveRadius * Math.sin(t * petals)
            const x = cx + Math.cos(t) * r
            const y = cy + Math.sin(t) * r
            if (i === 0)
            ctx.moveTo(x, y)
            else
            ctx.lineTo(x, y)
        }
        ctx.closePath()
        ctx.fillStyle = Appearance.primary_container
        ctx.fill()
    }
}