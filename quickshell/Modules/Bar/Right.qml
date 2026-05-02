import QtQuick
import Quickshell

PanelWindow {
    id: right

    color: "transparent"
    implicitWidth: cornerRight.width
    implicitHeight: cornerRight.height

    anchors {
        top: true
        right: true
    }

    Canvas {
        id: cornerRight

        width: 30
        height: 30
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(width, 0);
            ctx.lineTo(0, 0);
            ctx.quadraticCurveTo(width, 0, width, height);
            ctx.closePath();
            ctx.fillStyle = "#181821";
            ctx.fill();
        }
    }

}
