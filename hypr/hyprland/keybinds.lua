local terminal = "kitty"
local fileManager = "nautilus"
local menu = "rofi -show drun"
local browser = "brave"

-- Windows
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind(
	"SUPER + SHIFT + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- quickshell
hl.bind("SUPER + G", hl.dsp.global("quickshell:powermenu"))
hl.bind("SUPER + M", hl.dsp.global("quickshell:mediaController"))
hl.bind("SUPER + Y", hl.dsp.global("quickshell:clock"))
hl.bind("SUPER + L", hl.dsp.global("quickshell:lock"))

-- FileManagers
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))

-- Terminals
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("ghostty"))

-- Browsers
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("firefox"))

--Cliphist
hl.bind("SUPER + D", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p ' '  -no-show-icons -display-columns 2 | cliphist decode | wl-copy"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("cliphist wipe"))

--Launchers
hl.bind("SUPER + R", hl.dsp.exec_cmd(menu))

-- Hyprpicker
hl.bind("SUPER + A", hl.dsp.exec_cmd("hyprpicker -a"))

--Hyprshot
hl.bind("SUPER + U", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Screenshots"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("hyprshot -m window -o $HOME/Screenshots"))
hl.bind("SUPER + print", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Screenshots"))

-- Wallpapers & toggle-theme
hl.bind("SUPER + W", hl.dsp.exec_cmd("$HOME/.config/rofi/scripts/WallpaperPicker.sh"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/dark-mode.sh"))

-- Move focus with mainMod + arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- windows
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "Window: Fullscreen" })
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }),
    { description = "Window: Fullscreen spoof" })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })