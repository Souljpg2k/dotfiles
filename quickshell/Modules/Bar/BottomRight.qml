import "../Themes"
import QtQuick
import Quickshell

PanelWindow {
    color: "transparent"
    implicitWidth: 30
    implicitHeight: 30

    anchors {
        bottom: true
        right: true
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.moveTo(width, height);
            ctx.lineTo(0, height);
            ctx.quadraticCurveTo(width, height, width, 0);
            ctx.closePath();
            ctx.fillStyle = Theme.bg;
            ctx.fill();
        }
    }

}
