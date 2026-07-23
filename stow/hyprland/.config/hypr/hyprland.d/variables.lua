local ipc = "qs -c noctalia-shell ipc call"

local vars = {
	terminal = "kitty",
	secondaryTerminal = "foot",
	browser = "firefox",
	fileManager = "kitty -f yazi",
	readingApp = "zathura",

	menu = ipc .. " launcher toggle",
	clipboardMenu = ipc .. " launcher clipboard",
	emojiPicker = ipc .. " launcher emoji",

	toggleBar = ipc .. " bar toggle",
	toggleNotification = ipc .. " notifications toggleHistory",
	toggleDashboard = ipc .. " controlCenter toggle",
	togglePowerMenu = ipc .. " sessionMenu toggle",
	toggleSettings = ipc .. " settings toggle",

	shell = "qs -c noctalia-shell --no-duplicate",
	storePastedText = "wl-paste --type text --watch cliphist store",
	storePastedImage = "wl-paste --type image --watch cliphist store",
	lockScreen = "hyprlock"
}

return vars
