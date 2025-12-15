{ pkgs, ... }:

{
	home-manager.users.quixaq = { lib, config, ... }: {
		home.packages = [];
		services.hypridle.enable = true;
		programs.bash = {
			enable = true;
		};
		xdg.enable = true;
		xdg.mimeApps.defaultApplications = {
			"text/html" = [ "chromium.desktop" ];
			"x-scheme-handler/http" = [ "chromium.desktop" ];
			"x-scheme-handler/https" = [ "chromium.desktop" ];
		};
		services.mpd = {
			enable = true;
			musicDirectory = "/home/quixaq/Music";
			extraConfig = ''
				audio_output {
					type "pipewire"
					name "My PipeWire Output"
				}
			'';
		};
		# ANCHOR kitty
		programs.kitty = lib.mkForce {
			enable = true;
			settings = {
				foreground = "#bdc3df";
				background = "#1f1f2a";
				selection_foreground = "#1f1f2a";
				selection_background = "#bdc3df";

				cursor = "#bdc3df";
				cursor_text_color = "#1f1f2a";
				url_color = "#85b6ff";

				tab_bar_background = "#1f1f2a";
				active_tab_foreground = "#bdc3df";
				active_tab_background = "#43435a";
				inactive_tab_foreground = "#dedeff";
				inactive_tab_background = "#1f1f2a";

				color0 = "#43435a";
				color1 = "#ff568e";
				color2 = "#64de83";
				color3 = "#efff73";
				color4 = "#73a9ff";
				color5 = "#946ff7";
				color6 = "#62c6da";
				color7 = "#dedeff";
				color8 = "#53536b";
				color9 = "#ff69a2";
				color10 = "#73de8a";
				color11 = "#f3ff85";
				color12 = "#85b6ff";
				color13 = "#a481f7";
				color14 = "#71c2d9";
				color15 = "#ebebff";
			};
		};
		# ANCHOR fastfetch
		programs.fastfetch = lib.mkForce {
			enable = true;
			settings = {
				logo = {
					color = {
						"1" = "#967ce2";
						"2" = "#8951c1";
					};
				};
				display = {
					color = {
						title = "#b19cd9";
						separator = "#ff6961";
						keys = "#b19cd9";
						output = "#eec1cb";
					};
					hideCursor = false;
				};
				modules = [
					"title"
					"separator"
					"os"
					"host"
					"kernel"
					"uptime"
					"packages"
					"shell"
					"display"
					"de"
					"wm"
					"wmtheme"
					"theme"
					"icons"
					"font"
					"cursor"
					"terminal"
					"terminalfont"
					"cpu"
					"gpu"
					"memory"
					"swap"
					"disk"
					"battery"
					"poweradapter"
					"locale"
					"break"
					"colors"
				];
			};
		};

		# ANCHOR hyprlock
		programs.hyprlock = lib.mkForce {
			enable = true;
			extraConfig = ''
			# Configuration
		# (general settings)
		general {
				grace = 2
				hide_cursor = true
				ignore_empty_input = true
				text_trim = true
		}
		# (background config)
		background {
				blur_passes = 3 # 0 disables blurring
				blur_size = 1
				noise = 0.01
				contrast = 0.8916
				brightness = 0.7
				vibrancy = 0.1696
				vibrancy_darkness = 0.0
		}
#

# Password input
		input-field {
				monitor =
				size = 225, 50
				outline_thickness = -1
				dots_size = 0.33
				dots_spacing = 0.45
				dots_center = true
				dots_rounding = -1
				outer_color = rgba(0,0,0,0)
				inner_color = rgba(0,0,0,0)
				font_color = rgb(ffd6fe)
				fade_on_empty = true
				fade_timeout = 1000
				font_family = Product Sans
				placeholder_text =
				hide_input = false
				rounding = 4
				check_color = rgba(0,0,0,0)
				fail_color = rgba(0,0,0,0)
				fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
				fail_transition = 200
				capslock_color = -1
				numlock_color = -1
				bothlock_color = -1
				invert_numlock = false
				swap_font_color = false
				position = 0, 150
				halign = center
				valign = bottom
		}
#


# Time
		# (hours)
		label {
				monitor =
				text = cmd[update:1000] echo -e "$(date +"%H")"
				color = rgb(ffd6fe)
				shadow_pass = 2
				shadow_size = 3
				shadow_color = rgb(0,0,0)
				shadow_boost = 1.2
				font_size = 150
				font_family = Roboto Light
				position = 0, 90
				halign = center
				valign = center
		}
		# (minutes)
		label {
				monitor =
				text = cmd[update:1000] echo -e "$(date +"%M")"
				color = rgb(ffd6fe)
				font_size = 150
				font_family = Roboto Light
				position = 0, -90
				halign = center
				valign = center
		}
#

# Date
		# (label)
		label {
				monitor =
				text = cmd[update:1000] echo -e "$(date +"%A, %B %d")"
				color = rgb(ffd6fe)
				font_size = 15
				font_family = Roboto Medium
				position = 100, -75
				shadow_passes = 5
				shadow_size = 10
				halign = left
				valign = top
		}
		# (icon)
		label {
				monitor =
				text = calendar_today
				color = rgb(ffd6fe)
				font_size = 15
				font_family = Material Symbols Outlined
				position = 75, -75
				shadow_passes = 5
				shadow_size = 10
				halign = left
				valign = top
		}
#

# Input layout
		# (label)
		label {
				monitor =
				text = $LAYOUT
				color = rgb(ffd6fe)
				font_size = 15
				font_family = Roboto Medium
				position = 100, -110
				shadow_passes = 5
				shadow_size = 10
				halign = left
				valign = top
		}
		# (icon)
		label {
				monitor =
				text = keyboard
				color = rgb(ffd6fe)
				font_size = 15
				font_family = Material Symbols Outlined
				position = 75, -112
				shadow_passes = 5
				shadow_size = 10
				halign = left
				valign = top
		}
#

# Battery
		# (label)
		label {
				monitor =
				text = cmd[update:1000] . ~/dotfiles/scripts/battery.sh status
				color = rgb(ffd6fe)
				font_size = 15
				font_family = Roboto Medium
				position = 100, -145
				shadow_passes = 5
				shadow_size = 10
				halign = left
				valign = top
		}
		# (icon)
		label {
				monitor =
				text = cmd[update:1000] . ~/dotfiles/scripts/battery.sh icon
				color = rgb(ffd6fe)
				font_size = 15
				font_family = Material Symbols Outlined
				position = 78, -145
				shadow_passes = 5
				shadow_size = 10
				halign = left
				valign = top
		}
'';
		};
		programs.waybar.enable = true;
		wayland.windowManager.hyprland.enable = true;
		wayland.windowManager.hyprland.systemd.enable = false;
		# hint Electron apps to use Wayland:
		home.sessionVariables.NIXOS_OZONE_WL = "1";

		wayland.windowManager.hyprland.settings = {
			# ANCHOR hyprland keybinds
			"$mod" = "SUPER";
			bind =
				[
					"$mod, Q, exec, kitty"
					"$mod, C, killactive,"
					"$mod, E, exec, thunar"
					"$mod, V, togglefloating,"
					"$mod, SPACE, exec, rofi -config ~/.local/share/rofi/themes/custom.rasi -show drun"
					"$mod, F, fullscreen"
					"$mod, B, exec, chromium"
					"$mod, Print, exec, hyprshot --clipboard-only -m region -z"
					"$mod, L, exec, mpc status | grep -q '\\[playing\\]' ; playing=$? ; mpc pause ; hyprlock ; if [ \"$playing\" -eq 0 ] ; then mpc play ; fi"
					"$mod, O, exec, hyprpicker -a -l"
					", F21, exec, hyprlock"
					"$mod, semicolon, exec, smile"
					", F19, exec, mpc toggle"
					"$mod, P, exec, kitty python"
					"$mod, H, exec, kitty --class clipse -e clipse"


					# move focus with mod + arrows
					"$mod, left, movefocus, l"
					"$mod, right, movefocus, r"
					"$mod, up, movefocus, u"
					"$mod, down, movefocus, d"

					# same for wasd
					"$mod, A, movefocus, l"
					"$mod, D, movefocus, r"
					"$mod, W, movefocus, u"
					"$mod, S, movefocus, d"

					# scratchpad
					"$mod, G, togglespecialworkspace, magic"
					"$mod SHIFT, G, movetoworkspace, special:magic"

					# scroll through existing workspaces with mod + scroll
					"$mod, mouse_down, workspace, e+1"
					"$mod, mouse_up, workspace, e-1"

					# exit hyprland
					"$mod CTRL SHIFT, M, exit"
				]
				++ (
					# workspaces
					# binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
					builtins.concatLists (builtins.genList (i:
							let ws = i + 1;
							in [
								"$mod, code:1${toString i}, workspace, ${toString ws}"
								"$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
							]
						)
						10)
				);
			bindm =
				[
					# move/resize windows with mod + lmb/rmb and dragging
					"$mod, mouse:272, movewindow"
					"$mod, mouse:273, resizewindow"
				];

			# ANCHOR hyprland env variables
			env =
				[
					"XCURSOR_SIZE,24"
					"HYPRCURSOR_THEME,rose-pine-hyprcursor"
					"HYPRCURSOR_SIZE,28"
					"XDG_CURRENT_DESKTOP,Hyprland"
					"XDG_SESSION_TYPE,wayland"
					"XDG_SESSION_DESKTOP,Hyprland"
					"QT_QPA_PLATFORM,wayland;xcb"
					"QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
					"QT_AUTO_SCREEN_SCALE_FACTOR,1"
					"GDK_SCALE,1"
					"SDL_VIDEODRIVER,wayland"
					"ELECTRON_ENABLE_WAYLAND,1"
					"ELECTRON_OZONE_PLATFORM_HINT,wayland"
					"XDG_UTILS_TERMINAL,kitty"
					"XDG_UTILS_BROWSER,chromium"
					"XDG_UTILS_FILEMANAGER,thunar"
					"GTK_THEME,Adwaita-dark"
				];

			# ANCHOR hyprland autostart
			exec-once =
				[
					"waybar"
					"ckb-next"
					"mullvad-vpn"
					"ydotoold"
					"clipse -listen"
				];

			windowrule =
				[
					"tile, class:^(Chromium)$"
					"float, class:^(blueman-manager)$"
					"float, class:^(nm-connection-editor)$"
					"float, class:^(com.github.Aylur.ags)$"
					"suppressevent maximize, class:.*"
					"nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
					"float, class:(clipse)"
					"size 622 652, class:(clipse)"
					"stayfocused, class:(clipse)"
				];

			layerrule =
				[
					"noanim, walker"
					"noanim, selection"
					"noanim, overview"
					"noanim, anyrun"
					"noanim, popup.*"
					"noanim, hyprpicker"
					"noanim, notifications"
				];

			# ANCHOR hyprland look and feel
			general = {
				gaps_in = 5;
				gaps_out = 14;

				border_size = 2;

				"col.active_border" = "rgb(ffd6fe)";
				"col.inactive_border" = "rgb(303030)";

				# disable resizing windows by clicking and dragging on border
				resize_on_border = false;

				# disable tearing
				allow_tearing = false;

				layout = "dwindle";
			};

			decoration = {
				rounding = 20;
				rounding_power = 2;

				active_opacity = "1.0";
				inactive_opacity = "1.0";
				fullscreen_opacity = "1.0";

				shadow = {
					enabled = true;
					range = 10;
					render_power = 3;
					color = "0x66000000";
				};

				blur = {
					enabled = false;
				};
			};

			animations = {
				enabled = true;

				# default animations
				bezier =
					[
						"linear, 0, 0, 1, 1"
						"md3_standard, 0.2, 0, 0, 1"
						"md3_decel, 0.05, 0.7, 0.1, 1"
						"md3_accel, 0.3, 0, 0.8, 0.15"
						"overshot, 0.05, 0.9, 0.1, 1.1"
						"crazyshot, 0.1, 1.5, 0.76, 0.92"
						"hyprnostretch, 0.05, 0.9, 0.1, 1.0"
						"menu_decel, 0.1, 1, 0, 1"
						"menu_accel, 0.38, 0.04, 1, 0.07"
						"easeInOutCirc, 0.85, 0, 0.15, 1"
						"easeOutCirc, 0, 0.55, 0.45, 1"
						"easeOutExpo, 0.16, 1, 0.3, 1"
						"softAcDecel, 0.26, 0.26, 0.15, 1"
						"bezier = md2, 0.4, 0, 0.2, 1"
					];
				animation =
					[
						"windows, 1, 3, md3_decel, popin 60%"
						"windowsIn, 1, 3, md3_decel, popin 60%"
						"windowsOut, 1, 3, md3_accel, popin 60%"
						"border, 1, 10, default"
						"fade, 1, 3, md3_decel"
						"layers, 1, 2, md3_decel, slide"
						"layersIn, 1, 3, menu_decel, slide"
						"layersOut, 1, 1.6, menu_accel, slide"
						"fadeLayersIn, 1, 2, menu_decel"
						"fadeLayersOut, 1, 4.5, menu_accel"
						"workspaces, 1, 7, menu_decel, slide"
						"specialWorkspace, 1, 3, md3_decel, slidevert"
					];
			};

			dwindle = {
				pseudotile = true;
				preserve_split = true;
			};

			master = {
				smart_resizing = true;
				new_on_active = true;
				drop_at_cursor = true;
			};

			misc = {
				vfr = 1;
				vrr = 1;
				animate_manual_resizes = false;
				animate_mouse_windowdragging = false;
				disable_splash_rendering = true;
				force_default_wallpaper = "0";
				disable_hyprland_logo = true;
				new_window_takes_over_fullscreen = 2;
				allow_session_lock_restore = false;
				initial_workspace_tracking = false;
				middle_click_paste = false;
			};

			# ANCHOR hyprland input
			input = {
				kb_layout = "pl";
				kb_options = "fkeys:basic_13-24"; # allow keys F13-F24 for keybinds
				follow_mouse = 1;
				accel_profile = "flat"; # disable mouse acceleration
			};

			# monitors
			monitor = "HDMI-A-1,2560x1080@75,0x0,1";

			# disable nag
			ecosystem = {
				no_update_news = true;
				no_donation_nag = true;
			};
		};

		# ANCHOR rofi
		programs.rofi = {
			enable = true;
			theme = let
				inherit (config.lib.formats.rasi) mkLiteral;
			in {
				"*" = {
					font = "Roboto 13";
					g-spacing = mkLiteral "10px";
					g-margin = 0;
					b-color = mkLiteral "#000000FF";
					fg-color = mkLiteral "#FFD6FEFF";
					fgp-color = mkLiteral "#888888FF";
					b-radius = mkLiteral "20px";
					g-padding = mkLiteral "8px";
					hl-color = mkLiteral "#FFD6FEFF";
					hlt-color = mkLiteral "#303030FF";
					alt-color = mkLiteral "#303030FF";
					wbg-color = mkLiteral "#303030FF";
					w-border = mkLiteral "2px solid";
					w-border-color = mkLiteral "#FFD6FEFF";
					w-padding = mkLiteral "12px";
				};
				configuration = {
					modi = "drun";
					show-icons = true;
					display-drun = "";
				};
				"listview" = {
					columns = 1;
					lines = 7;
					fixed-height = true;
					fixed-columns = true;
					cycle = false;
					scrollbar = false;
					border = mkLiteral "0px solid";
				};
				"window" = {
					transparency = "real";
					width = mkLiteral "450px";
					border-radius = mkLiteral "@b-radius";
					background-color = mkLiteral "@wbg-color";
					border = mkLiteral "@w-border";
					border-color = mkLiteral "@w-border-color";
					padding = mkLiteral "@w-padding";
				};
				"prompt" = {
					text-color = mkLiteral "@fg-color";
				};
				"inputbar" = {
					children = ["prompt" "entry"];
					spacing = mkLiteral "@g-spacing";
				};
				"entry" = {
					placeholder = "Search Apps";
					text-color = mkLiteral "@fg-color";
					placeholder-color = mkLiteral "@fgp-color";
				};
				"mainbox" = {
					spacing = mkLiteral "@g-spacing";
					margin = mkLiteral "@g-margin";
					padding = mkLiteral "@g-padding";
					children = ["inputbar" "listview" "message"];
				};
				"element" = {
					spacing = mkLiteral "@g-spacing";
					margin = mkLiteral "@g-margin";
					padding = mkLiteral "@g-padding";
					border = mkLiteral "0px solid";
					border-radius = mkLiteral "@b-radius";
					border-color = mkLiteral "@b-color";
					background-color = mkLiteral "transparent";
					text-color = mkLiteral "@fg-color";
				};
				"element normal normal" = {
					background-color = mkLiteral "transparent";
					text-color = mkLiteral "@fg-color";
				};
				"element alternate normal" = {
					background-color = mkLiteral "@alt-color";
					text-color = mkLiteral "@fg-color";
				};
				"element selected active" = {
					background-color = mkLiteral "@hl-color";
					text-color = mkLiteral "@hlt-color";
				};
				"element selected normal" = {
					background-color = mkLiteral "@hl-color";
					text-color = mkLiteral "@hlt-color";
				};
				"message" = {
					background-color = mkLiteral "red";
					border = mkLiteral "0px solid";
				};
			};
		};

		programs.waybar.settings.main = {
			# ANCHOR waybar settings
			layer = "top";
			position = "top";
			modules-left =
				[
					"clock"
				];
			modules-center =
				[

				];
			modules-right =
				[
					"tray"
				];
			tray = {
				icon-size = 21;
				spacing = 10;
			};
			"custom/music" = {
				format = "{}";
				escape = true;
				interval = 5;
				tooltip = false;
				exec = "playerctl metadata --format='{{ title }}'";
				on-click = "playerctl play-pause";
				max-lenght = 50;
			};
			clock = {
				tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
				format-alt = "{:%d/%m/%Y}";
				format = "{:%H:%M}";
			};
			backlight = {
				device = "intel_backlight";
				format = "{icon}";
				format-icons = ["" "" "" "" "" "" "" "" ""];
			};
			battery = {
				states = {
						warning = 30;
						critical = 15;
				};
				format = "{icon}";
				format-charging = "";
				format-plugged = "";
				format-alt = "{icon}";
				format-icons = ["" "" "" "" "" "" "" "" "" "" "" ""];
			};
			pulseaudio = {
				# "scroll-step": 1, // %, can be a float
				format = "{icon} {volume}%";
				format-muted = "";
				format-icons = {
						default = ["" "" " "];
				};
				on-click = "pavucontrol";
			};
			"hyprland/workspaces" = {
				format = "{icon}";
				on-scroll-up = "hyprctl dispatch workspace e+1";
				on-scroll-down = "hyprctl dispatch workspace e-1";
			};
		};
		# ANCHOR waybar style
		programs.waybar.style = "
@define-color bg #303030;
@define-color my #ffd6fe;

* {
	font-family: Roboto;
	font-size: 17px;
	min-height: 0;
}

#waybar {
	background: transparent;
	margin: 5px 5px;
}

#custom-music,
#tray,
#clock {
	background-color: @bg;
	padding: 0.5rem 1rem;
	margin: 5px 0;
	color: @my;
	border-radius: 19px / 50%;
}

#clock {
	margin-left: 1rem;
}

#tray {
	margin-right: 1rem;
}
		";

		gtk = {
			enable = true;
			theme = {
				name = "Adwaita-dark";
				package = pkgs.gnome-themes-extra;
			};
		};

		# The state version is required and should stay at the version you
		# originally installed.
		home.stateVersion = "25.05";
	};
	home-manager.backupFileExtension = "backup";
}
