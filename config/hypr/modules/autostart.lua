local cmds = {
    "waybar",
    "swaybg -c '#1a1a1a' -m solid_color",
    "ckb-next -b",
    "mullvad-vpn",
    "ydotoold",
    "clipse -listen",
    "legcord",
    "steam"
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(cmds) do
        hl.exec_cmd("uwsm-app -- " .. cmd)
    end
end)
