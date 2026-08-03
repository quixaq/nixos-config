local execbinds = {
    { "SUPER + V",                          "uwsm-app -- kitty" },
    { "SUPER + L",                          "uwsm-app -- kitty -o confirm_os_window_close=0 -e yazi" },
    { "SUPER + SPACE",                      "dms ipc call spotlight toggle" },
    { "SUPER + W",                          "uwsm-app -- trivalent" },
    { "SUPER + Print",                      "uwsm-app -- hyprshot --clipboard-only -m region -z" },
    { "SUPER + E",                          "loginctl lock-session" },
    { "F21",                                "loginctl lock-session" },
    { "SUPER + U",                          "uwsm-app -- hyprpicker -a -l" },
    { "SUPER + I",                          "uwsm-app -- smile" },
    { "F19",                                "mpc toggle" },
    { "SUPER + J",                          "uwsm-app -- kitty -o confirm_os_window_close=0 -e python" },
    { "SUPER + period",                     "dms ipc call clipboard toggle" },
    { "SUPER + Z",                          "uwsm-app -- gram" },
    { "SUPER + SHIFT + CTRL + ALT + minus", "/run/wrappers/bin/panicshutdown" },
    { "SUPER + SHIFT + CTRL + ALT + equal", "systemctl poweroff" },
    { "SUPER + CTRL + SHIFT + ALT + H",     "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'" }
}

for _, bind in ipairs(execbinds) do
    hl.bind(bind[1], hl.dsp.exec_cmd(bind[2]))
end

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + CTRL + SHIFT + Q", hl.dsp.window.kill())
hl.bind("SUPER + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + D", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + S", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + R", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + M", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + T", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + CTRL + H", hl.dsp.workspace.move({ monitor = "+1" }))

hl.bind("SUPER + Y", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + Y", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "-1" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 0, 9 do
    hl.bind("SUPER + code:1" .. i, hl.dsp.focus({ workspace = tostring(i + 1) }))
    hl.bind("SUPER + SHIFT + code:1" .. i, hl.dsp.window.move({ workspace = tostring(i + 1) }))
end
