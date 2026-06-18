hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 14,

        border_size = 2,

        col = {
            active_border = { colors = { "rgb(ffd6fe)" } },
            inactive_border = { colors = { "rgb(303030)" } }
        },

        resize_on_border = false,

        allow_tearing = false,

        layout = "dwindle"
    },

    decoration = {
        rounding = 20,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
            color = 0x66000000
        },

        blur = {
            enabled = false
        }
    },

    animations = {
        enabled = true
    },

    dwindle = {
        preserve_split = true
    },

    master = {
        smart_resizing = true,
        new_on_active = "1",
        drop_at_cursor = true
    },

    misc = {
        vrr = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        disable_splash_rendering = true,
        on_focus_under_fullscreen = 2,
        allow_session_lock_restore = false,
        initial_workspace_tracking = false,
        middle_click_paste = false
    },

    input = {
        kb_layout = "pl",
        kb_options = "fkeys:basic_13-24",
        follow_mouse = true,
        accel_profile = "flat"
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true
    }
})
