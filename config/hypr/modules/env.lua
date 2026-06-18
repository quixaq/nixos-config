local env = {
    { "XCURSOR_SIZE",                        "28" },
    { "HYPRCURSOR_THEME",                    "rose-pine-hyprcursor" },
    { "HYPRCURSOR_SIZE",                     "28" },
    { "XDG_CURRENT_DESKTOP",                 "Hyprland" },
    { "XDG_SESSION_TYPE",                    "wayland" },
    { "XDG_SESSION_DESKTOP",                 "Hyprland" },
    { "QT_QPA_PLATFORM",                     "wayland;xcb" },
    { "QT_WAYLAND_DISABLE_WINDOWDECORATION", "1" },
    { "QT_AUTO_SCREEN_SCALE_FACTOR",         "1" },
    { "GDK_SCALE",                           "1" },
    { "SDL_VIDEODRIVER",                     "wayland" },
    { "ELECTRON_ENABLE_WAYLAND",             "1" },
    { "ELECTRON_OZONE_PLATFORM_HINT",        "wayland" },
    { "XDG_UTILS_TERMINAL",                  "kitty" },
    { "XDG_UTILS_BROWSER",                   "chromium" },
    { "XDG_UTILS_FILEMANAGER",               "thunar" },
    { "GTK_THEME",                           "Adwaita-dark" }
}

for _, item in ipairs(env) do
    hl.env(item[1], item[2])
end
