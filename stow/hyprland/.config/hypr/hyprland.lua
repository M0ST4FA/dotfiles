hl.monitor({
	output = "",
	mode = "1920x1080@144",
	position = "0x0",
	scale = "1.25",
})

-- Add hyprland.d to the Lua search path so we can require its contents directly
local conf_dir = os.getenv("HOME") .. "/.config/hypr/hyprland.d/"
package.path = package.path .. ";" .. conf_dir .. "?.lua"

require("environment")
require("autostart")
require("keybinds")
require("windowrules")
require("layerrules")
require("decoration")
require("animations")
require("layout")
require("input")
require("gestures")
require("xwayland")
require("misc")
require("plugins")
