import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import QtQuick.Effects

Item {
    id: clockItem
    width: 150
    height: 150

    Item {
        anchors.fill: parent

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Appearance.shadow
            shadowBlur: 0.3
            saturation: -0.4
        }

        ScallopedCircle {}
    }

    Item {
        anchors.fill: parent

        ScallopedCircle {}

        Column {
            anchors.centerIn: parent
        
            spacing: -20
            opacity: 0.5

            component TimeText: StyledText {
                font.pixelSize: Appearance.base + 40
                color: Appearance.background
                font.bold: true
            }

            TimeText {
                text: DateTimeService.hours
            }

            TimeText {
                text: DateTimeService.ap
                font.pixelSize: Appearance.base + 20
            }
        }

        Rectangle {
            id: minutes
            width: 8
            height: 58
            radius: width / 2
            color: Appearance.background
            opacity: 0.9

            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height

            transform: Rotation {
                origin.x: minutes.width / 2
                origin.y: minutes.height
                angle: DateTimeService.minutes * 6 + DateTimeService.seconds * 0.1
            }
        }

        Rectangle {
            id: hours
            width: 12
            height: 45
            radius: width / 2
            color: Appearance.background

            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height

            transform: Rotation {
                origin.x: hours.width / 2
                origin.y: hours.height
                angle: (DateTimeService.hours % 12) * 30 + DateTimeService.minutes * 0.5
            }
        }

        Rectangle {
            id: dot
            anchors.centerIn: parent
            width: 6
            height: 6
            radius: width / 2
            color: Appearance.primary_container

            layer.enabled: true
            layer.effect: MultiEffect {
                saturation: -0.4
            }
        }
    }
}