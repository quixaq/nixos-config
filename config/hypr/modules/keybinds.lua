local execbinds = {
    { "SUPER + Q",                          "uwsm-app -- kitty" },
    { "SUPER + E",                          "uwsm-app -- kitty -o confirm_os_window_close=0 -e yazi" },
    { "SUPER + SPACE",                      "uwsm-app -- rofi -config ~/.local/share/rofi/themes/custom.rasi -show drun" },
    { "SUPER + B",                          "uwsm-app -- chromium" },
    { "SUPER + Print",                      "uwsm-app -- hyprshot --clipboard-only -m region -z" },
    { "SUPER + L",                          "loginctl lock-session" },
    { "F12",                                "loginctl lock-session" },
    { "SUPER + O",                          "uwsm-app -- hyprpicker -a -l" },
    { "SUPER + semicolon",                  "uwsm-app -- smile" },
    { "F19",                                "mpc toggle" },
    { "SUPER + P",                          "uwsm-app -- kitty -o confirm_os_window_close=0 -e python" },
    { "SUPER + H",                          "uwsm-app -- kitty --class clipse -o confirm_os_window_close=0 -e clipse" },
    { "SUPER + Z",                          "uwsm-app -- zeditor" },
    { "SUPER + SHIFT + CTRL + ALT + minus", "/run/wrappers/bin/panicshutdown" },
    { "SUPER + SHIFT + CTRL + ALT + equal", "systemctl poweroff" },
    { "SUPER + CTRL + SHIFT + ALT + M",     "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'" }
}

for _, bind in ipairs(execbinds) do
    hl.bind(bind[1], hl.dsp.exec_cmd(bind[2]))
end

hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + CTRL + SHIFT + C", hl.dsp.window.kill())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + A", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + D", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + W", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + S", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + CTRL + M", hl.dsp.workspace.move({ monitor = "+1" }))

hl.bind("SUPER + G", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + G", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "-1" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 0, 9 do
    hl.bind("SUPER + code:1" .. i, hl.dsp.focus({ workspace = tostring(i + 1) }))
    hl.bind("SUPER + SHIFT + code:1" .. i, hl.dsp.window.move({ workspace = tostring(i + 1) }))
end
