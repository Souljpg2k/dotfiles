pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root

    property string currentLayout: ""

    function setLayout(name) {
        currentLayout = name.substring(0, 2).toLowerCase()
    }

    Process {
        id: kbproc
        command: ["hyprctl", "devices", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                const kb = JSON.parse(text).keyboards.find(k => k.main)
                if (kb)
                    root.setLayout(kb.active_keymap)
            }
        }
    }

    Component.onCompleted: {
        kbproc.running = true

        Hyprland.rawEvent.connect(event => {
            if (event.name === "activelayout")
                root.setLayout(event.data.split(",").pop().trim())
        })
    }
}