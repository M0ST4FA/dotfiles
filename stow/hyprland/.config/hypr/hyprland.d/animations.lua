hl.config({
    animations = {
        enabled = true,
    }
})

hl.curve("navigation", { type = "bezier", points = {{0.3, 1}, {0.6, 1}} })
hl.curve("softSpring", { type = "bezier", points = {{0.35, 1.2}, {0.35, 1}} })
hl.curve("strongSpring", { type = "bezier", points = {{0.4, 1.5}, {0.5, 1}} })
hl.curve("fast", { type = "bezier", points = {{0.2, 0.8}, {0.3, 1}} })

hl.animation({ leaf = "global", enabled = true, speed = 4.5, bezier = "navigation" })
hl.animation({ leaf = "border", enabled = true, speed = 3.5, bezier = "navigation" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 3.5, bezier = "navigation" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "navigation" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.5, bezier = "strongSpring", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.5, bezier = "softSpring", style = "popin 90%" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.0, bezier = "fast" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.8, bezier = "fast" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.8, bezier = "fast" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.2, bezier = "navigation" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.5, bezier = "softSpring", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.8, bezier = "navigation", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "navigation", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 4.0, bezier = "navigation", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 4.0, bezier = "navigation", style = "slide" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 2.2, bezier = "fast" })
