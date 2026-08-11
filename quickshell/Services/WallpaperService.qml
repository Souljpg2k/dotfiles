pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string cacheFile: Quickshell.env("HOME") + "/.cache/current_wallpaper"

    property string wallpaperPath: ""

    FileView {
        id: wallpaperFile
        path: root.cacheFile
        watchChanges: true

        onLoaded: {
            const t = text().trim()
            if (t.length > 0)
            root.wallpaperPath = t
        }
        onFileChanged: reload()
    }
}