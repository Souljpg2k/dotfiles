import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import QtQuick.Layouts

StyledItem {
    width: Appearance.base + 25

    RowLayout {
        anchors.fill: parent

        MaterialIcon {
            text: WeatherService.weatherIcon(WeatherService.weatherCode)
            font.family: "Material Symbols Outlined"
        }

        StyledText {
            text: WeatherService.tempC + "°"
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: GlobalStates.weatherVisible = !GlobalStates.weatherVisible
    }
}