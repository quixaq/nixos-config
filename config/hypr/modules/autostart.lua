local cmds = {
    "waybar",
    "ckb-next",
    "mullvad-vpn",
    "ydotoold",
    "clipse -listen",
    "swaybg -c '#1a1a1a' -m solid_color"
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(cmds) do
        hl.exec_cmd("uwsm-app -- " .. cmd)
    end
end)
