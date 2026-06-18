local bezier = {
    { "linear",        0,    0,    1,    1 },
    { "md3_standard",  0.2,  0,    0,    1 },
    { "md3_decel",     0.05, 0.7,  0.1,  1 },
    { "md3_accel",     0.3,  0,    0.8,  0.15 },
    { "overshot",      0.05, 0.9,  0.1,  1.1 },
    { "crazyshot",     0.1,  1.5,  0.76, 0.92 },
    { "hyprnostretch", 0.05, 0.9,  0.1,  1.0 },
    { "menu_decel",    0.1,  1,    0,    1 },
    { "menu_accel",    0.38, 0.04, 1,    0.07 },
    { "easeInOutCirc", 0.85, 0,    0.15, 1 },
    { "easeOutCirc",   0,    0.55, 0.45, 1 },
    { "easeOutExpo",   0.16, 1,    0.3,  1 },
    { "softAcDecel",   0.26, 0.26, 0.15, 1 },
    { "md2",           0.4,  0,    0.2,  1 }
}

local anim = {
    { "windows",          3,   "md3_decel",  "popin 60%" },
    { "windowsIn",        3,   "md3_decel",  "popin 60%" },
    { "windowsOut",       3,   "md3_accel",  "popin 60%" },
    { "border",           10,  "default" },
    { "fade",             3,   "md3_decel" },
    { "layers",           2,   "md3_decel",  "slide" },
    { "layersIn",         3,   "menu_decel", "slide" },
    { "layersOut",        1.6, "menu_accel", "slide" },
    { "fadeLayersIn",     2,   "menu_decel" },
    { "fadeLayersOut",    4.5, "menu_accel" },
    { "workspaces",       7,   "menu_decel", "slide" },
    { "specialWorkspace", 3,   "md3_decel",  "slidevert" }
}

for _, curve in ipairs(bezier) do
    hl.curve(curve[1], { type = "bezier", points = { { curve[2], curve[3] }, { curve[4], curve[5] } } })
end

for _, item in ipairs(anim) do
    if #item == 3 then
        hl.animation({ leaf = item[1], enabled = true, speed = item[2], bezier = item[3] })
    else
        hl.animation({ leaf = item[1], enabled = true, speed = item[2], bezier = item[3], style = item[4] })
    end
end
