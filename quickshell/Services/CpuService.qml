pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real cpuUsage: 0
    property real lastCpuTotal: 0
    property real lastCpuIdle: 0

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                const p = data.trim().split(/\s+/)
                const idle = parseInt(p[4]) + parseInt(p[5])
                const total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                const dt = total - lastCpuTotal
                if (dt > 0)
                    cpuUsage = Math.max(0, Math.min(100, Math.round(100 * (1 - (idle - lastCpuIdle) / dt))))
                lastCpuTotal = total
                lastCpuIdle = idle
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cpuProc.running = true
    }
}