import qs.Appearance
import QtQuick

Text {
    id: root
    color: Appearance.on_background
    font.family: "Google Sans Display"
    font.pixelSize: Appearance.base
    renderType: Text.NativeRendering
}