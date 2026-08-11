pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string memUsage: "0.0"

    Process {
        id: memProc
        command: ["sh", "-c", "grep -E 'MemTotal:|MemAvailable:' /proc/meminfo"]

        stdout: SplitParser {
            property int total: 0

            onRead: data => {
                const parts = data.trim().split(/\s+/)
                if (parts[0] === "MemTotal:")
                    total = Number(parts[1])
                else if (parts[0] === "MemAvailable:" && total > 0)
                    memUsage = ((total - Number(parts[1])) / 1048576).toFixed(1)
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: memProc.running = true
    }
}