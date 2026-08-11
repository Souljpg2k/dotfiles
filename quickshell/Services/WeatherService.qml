pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int tempC: 0
    property string weatherCode: "113"

    function weatherIcon(code) {
        const c = parseInt(code)
        if (c === 113) return "wb_sunny"
        if (c === 116) return "partly_cloudy_day"
        if (c === 119 || c === 122) return "cloud"
        if (c === 143 || c === 248 || c === 260) return "foggy"
        if (c >= 176 && c <= 185) return "rainy"
        if (c === 200) return "thunderstorm"
        if (c === 227 || c === 230) return "weather_snowy"
        if (c >= 263 && c <= 284) return "rainy"
        if (c >= 293 && c <= 308) return "rainy"
        if (c >= 311 && c <= 320) return "rainy"
        if (c >= 323 && c <= 338) return "weather_snowy"
        if (c === 350) return "weather_hail"
        if (c === 353 || c === 356 || c === 359) return "rainy"
        if (c === 362 || c === 365) return "rainy"
        if (c === 368 || c === 371) return "weather_snowy"
        if (c === 374 || c === 377) return "weather_hail"
        if (c >= 386 && c <= 395) return "thunderstorm"
        return "cloud"
    }

    Process {
        id: proc
        command: [
            "bash",
            "-c",
            "curl -sf 'wttr.in/?format=j1' | jq -r '.current_condition[0]|[.temp_C,.weatherCode]|@tsv'"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const p = text.trim().split("\t")
                if (p.length !== 2)
                return
                root.tempC = parseInt(p[0])
                root.weatherCode = p[1]
            }
        }
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: {
            if (!proc.running)
                proc.running = true
        }
    }
}