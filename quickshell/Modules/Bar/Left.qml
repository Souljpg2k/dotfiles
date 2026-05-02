import "../Themes"
import QtQuick
import Quickshell

PanelWindow {
    id: left

    color: "transparent"
    implicitWidth: cornerLeft.width
    implicitHeight: cornerLeft.height

    anchors {
        top: true
        left: true
    }

    Canvas {
        id: cornerLeft

        width: 30
        height: 30
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(width, 0);
            ctx.quadraticCurveTo(0, 0, 0, height);
            ctx.closePath();
            ctx.fillStyle = Theme.bg;
            ctx.fill();
        }
    }

}
