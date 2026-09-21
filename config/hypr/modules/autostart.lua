local cmds = {
    "dms run",
    "ckb-next -b",
    "hypridle",
    "mullvad-vpn",
    "listenbrainz-mpd",
    "sleep 5 ; mpdris2-rs",
    "ydotoold",
    --"legcord",
    "steam"
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(cmds) do
        hl.exec_cmd("uwsm-app -- " .. cmd)
    end
end)
