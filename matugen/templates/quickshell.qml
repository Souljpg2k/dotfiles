pragma Singleton

import Quickshell
import QtQuick

Singleton {
    
	readonly property int base: 16

	readonly property int radius: 18
	<* for name, value in colors *>
	readonly property color {{name}}: "{{value.default.hex}}"
	<* endfor *>
}