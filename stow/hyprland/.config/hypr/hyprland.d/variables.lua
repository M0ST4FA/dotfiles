-- local ipc = "qs -c noctalia-shell ipc call"
local ipc = "noctalia msg "
local screenshot_cmd = os.getenv("HOME") .. "/.local/bin/screenshot "

local vars = {
	terminal = "kitty",
	secondaryTerminal = "foot",
	browser = "firefox",
	fileManager = "kitty -f yazi",
	readingApp = "zathura",

	menu = ipc .. "panel-toggle launcher",
	clipboardMenu = ipc .. "panel-toggle clipboard",
	emojiPicker = ipc .. "panel-toggle emoji",

	toggleBar = ipc .. "bar-toggle",
	toggleNotification = ipc .. "panel-toggle control-center notifications",
	toggleDashboard = ipc .. "panel-toggle control-center",
	togglePowerMenu = ipc .. "panel-toggle session",
	toggleSettings = ipc .. "settings-toggle",

	shell = "noctalia",
	storePastedText = "wl-paste --type text --watch cliphist store",
	storePastedImage = "wl-paste --type image --watch cliphist store",
	lockScreen = "hyprlock",

	screenshot = screenshot_cmd .. "output",
	areaScreenshot = screenshot_cmd .. "area",
	activeScreenshot = screenshot_cmd .. "active",
	editScreenshot = screenshot_cmd .. "edit",
}

return vars
