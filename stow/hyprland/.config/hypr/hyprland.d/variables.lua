-- local ipc = "qs -c noctalia-shell ipc call"
local ipc = "noctalia msg "

local vars = {
	terminal = "kitty",
	secondaryTerminal = "foot",
	browser = "firefox",
	fileManager = "kitty -f yazi",
	readingApp = "zathura",

	-- menu = ipc .. " launcher toggle",
	-- clipboardMenu = ipc .. " launcher clipboard",
	-- emojiPicker = ipc .. " launcher emoji",
	--
	-- toggleBar = ipc .. " bar toggle",
	-- toggleNotification = ipc .. " notifications toggleHistory",
	-- toggleDashboard = ipc .. " controlCenter toggle",
	-- togglePowerMenu = ipc .. " sessionMenu toggle",
	-- toggleSettings = ipc .. " settings toggle",

	menu = ipc .. "panel-toggle launcher",
	clipboardMenu = ipc .. "panel-toggle clipboard",
	emojiPicker = ipc .. "panel-toggle emoji",

	toggleBar = ipc .. "bar-toggle",
	toggleNotification = ipc .. "panel-toggle control-center notifications",
	toggleDashboard = ipc .. "panel-toggle control-center",
	togglePowerMenu = ipc .. "panel-toggle session",
	toggleSettings = ipc .. "settings-toggle",

	-- shell = "qs -c noctalia-shell --no-duplicate",
	shell = "noctalia",
	storePastedText = "wl-paste --type text --watch cliphist store",
	storePastedImage = "wl-paste --type image --watch cliphist store",
	lockScreen = "hyprlock",

	screenshot = "grimblast --notify copysave output",
	areaScreenshot = "grimblast --notify copysave area",
	editScreenshot = "grimblast --notify edit output",
	activeScreenshot = "grimblast --notify copysave active",
}

return vars
