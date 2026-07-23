local vars = require("variables")
local mainMod = "SUPER"

-- Applications
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(vars.browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(vars.emojiPicker))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(vars.clipboardMenu))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(vars.toggleSettings))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(vars.toggleNotification))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd(vars.toggleBar))
hl.bind("ALT + space", hl.dsp.exec_cmd(vars.menu))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --notify copysave output"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("grimblast --notify copysave area"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("grimblast --notify edit output"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("grimblast --notify copysave active"))

-- OCR
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/ocr.sh"))

-- Session / WM
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(vars.togglePowerMenu))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(vars.lockScreen))

-- Maximize / Fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle", mode = 1 }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = 0 }))

-- Floating
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + W", function() hl.dispatch(hl.dsp.layout("focus float")) end)

-- Groups
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.group.next())

-- Column / window size
hl.bind(mainMod .. " + minus", function() hl.dispatch(hl.dsp.layout("colresize -0.05")) end)
hl.bind(mainMod .. " + equal", function() hl.dispatch(hl.dsp.layout("colresize +0.05")) end)
hl.bind(mainMod .. " + R", function() hl.dispatch(hl.dsp.layout("colresize -conf")) end)
hl.bind(mainMod .. " + SHIFT + R", function() hl.dispatch(hl.dsp.layout("colresize +conf")) end)
hl.bind(mainMod .. " + CTRL + F", function() hl.dispatch(hl.dsp.layout("fit visible")) end)

-- Window height
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = -50, y = 0 }))
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 50, y = 0 }))
hl.bind(mainMod .. " + CTRL + minus", hl.dsp.window.resize({ x = 0, y = -50 }))
hl.bind(mainMod .. " + CTRL + equal", hl.dsp.window.resize({ x = 0, y = 50 }))

-- Focus movement
hl.bind(mainMod .. " + H", function() hl.dispatch(hl.dsp.layout("focus l")) end)
hl.bind(mainMod .. " + L", function() hl.dispatch(hl.dsp.layout("focus r")) end)
hl.bind(mainMod .. " + K", function() hl.dispatch(hl.dsp.layout("focus u")) end)
hl.bind(mainMod .. " + J", function() hl.dispatch(hl.dsp.layout("focus d")) end)

-- Move windows
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "r" }))

hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + bracketleft", hl.dsp.window.move({ direction = "r" }))

hl.bind("ALT + TAB", hl.dsp.window.cycle_next("hist"))

hl.bind(mainMod .. " + C", hl.dsp.window.center())

-- Workspaces
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, function() hl.dispatch(hl.dsp.focus({ workspace = i })) end)
	hl.bind(mainMod .. " + SHIFT + " .. i, function() hl.dispatch(hl.dsp.window.move({ workspace = i })) end)
	hl.bind(mainMod .. " + CTRL + " .. i, function() hl.dispatch(hl.dsp.layout("movecoltoworkspace " .. i)) end)
end

hl.bind(mainMod .. " + 0", function() hl.dispatch(hl.dsp.focus({ workspace = 10 })) end)
hl.bind(mainMod .. " + SHIFT + 0", function() hl.dispatch(hl.dsp.window.move({ workspace = 10 })) end)

hl.bind(mainMod .. " + CTRL + H", function() hl.dispatch(hl.dsp.focus({ workspace = "r-1" })) end)
hl.bind(mainMod .. " + CTRL + L", function() hl.dispatch(hl.dsp.focus({ workspace = "r+1" })) end)
hl.bind(mainMod .. " + TAB", function() hl.dispatch(hl.dsp.focus({ workspace = "previous" })) end)

-- Mouse drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Zoom
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.2')"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.80) | if . < 1 then 1 else . end')"), { repeating = true })

-- Multimedia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { repeating = true, locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { repeating = true, locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl --class=backlight set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --class=backlight set 5%-"), { repeating = true, locked = true })
