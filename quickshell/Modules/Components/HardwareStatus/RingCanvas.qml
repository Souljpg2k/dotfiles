import "../../Themes"
import QtQuick

Canvas {
    anchors.fill: parent
    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        var cx = width / 2, cy = height / 2;
        var r = width / 2 - 3;
        var start = -Math.PI / 2;
        var end = start + (2 * Math.PI * ring.value / 100);
        ctx.beginPath();
        ctx.arc(cx, cy, r, 0, 2 * Math.PI);
        ctx.strokeStyle = Theme.lineColor;
        ctx.lineWidth = 2;
        ctx.stroke();
        if (ring.value > 0) {
            ctx.beginPath();
            ctx.arc(cx, cy, r, start, end);
            ctx.strokeStyle = Theme.fg;
            ctx.lineWidth = 2;
            ctx.lineCap = "round";
            ctx.stroke();
        }
    }

    Connections {
        function onValueChanged() {
            canvas.requestPaint();
        }

        target: ring
    }

}
