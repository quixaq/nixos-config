hl.window_rule({
    name = "clipse",
    match = { class = "clipse" },
    float = true,
    size = { 622, 652 },
    center = true
})

local noanim = {
    "walker",
    "selection",
    "overview",
    "anyrun",
    "popup.*",
    "hyprpicker",
    "notifications"
}

for _, item in ipairs(noanim) do
    hl.layer_rule({
        match = { namespace = item },
        no_anim = true
    })
end
