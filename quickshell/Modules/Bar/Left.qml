import "../Themes"
import QtQuick
import Quickshell

PanelWindow {
    color: "transparent"
    implicitWidth: 30
    implicitHeight: 30

    anchors {
        top: true
        left: true
    }

    Canvas {
        anchors.fill: parent
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
