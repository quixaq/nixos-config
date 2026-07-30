local cmds = {
    "dms run",
    "ckb-next -b",
    "hypridle",
    "mullvad-vpn",
    "ydotoold",
    "legcord",
    "steam"
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(cmds) do
        hl.exec_cmd("uwsm-app -- " .. cmd)
    end
end)
