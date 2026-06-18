{ pkgs, ... }:

let
  lockScript = pkgs.writeShellScript "lock" ''
    ! ${pkgs.uutils-procps}/bin/pgrep -x hyprlock > /dev/null && (${pkgs.mpc}/bin/mpc status | grep -q '\[playing\]' ; playing=$? ; ${pkgs.mpc}/bin/mpc pause ; ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 ; ${pkgs.hyprlock}/bin/hyprlock ; ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; if [ "$playing" -eq 0 ] ; then ${pkgs.mpc}/bin/mpc play ; fi)
  '';
in
{
  home-manager.users.quixaq =
    { lib, config, ... }:
    {
      imports = [
        ./shell.nix
      ];
      home.packages = [ ];
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
          replaygain "track"
          replaygain_preamp "0"
          audio_output {
            type "pipewire"
            name "My PipeWire Output"
          }
          			'';
      };

      # Git
      programs.git = {
        enable = true;
        settings = {
          user.name = "Quixaq";
          user.email = "quixaq@tutamail.com";
          user.signingKey = "/home/quixaq/.ssh/id_quixaq_signing";
          gpg.format = "ssh";
          commit.gpgsign = true;
          gpg.ssh.allowedSignersFile = "/home/quixaq/.ssh/allowed_signers";
        };
      };

      home.file.".ssh/allowed_signers".text = ''
        quixaq@tutamail.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7OlPMLAE4LtgxFaZxpyKT1lWKuzdwX3gl1KZi33MPZ
      '';

      # ANCHOR hypridle
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "${lockScript}";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
          ];
        };
      };

      # ANCHOR kitty
      programs.kitty = lib.mkForce {
        enable = true;
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 11;
        };
        settings = {
          bold_font = "auto";
          italic_font = "auto";
          bold_italic_font = "auto";

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
      wayland.windowManager.hyprland.configType = "lua";
      wayland.windowManager.hyprland.systemd.enable = false;
      # hint Electron apps to use Wayland:
      home.sessionVariables.NIXOS_OZONE_WL = "1";
      xdg.configFile."hypr" = {
        source = ../config/hypr;
        recursive = true;
      };

      # ANCHOR rofi
      programs.rofi = {
        enable = true;
        theme =
          let
            inherit (config.lib.formats.rasi) mkLiteral;
          in
          {
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
              children = [
                "prompt"
                "entry"
              ];
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
              children = [
                "inputbar"
                "listview"
                "message"
              ];
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

        extraConfig = {
          run-command = "uwsm-app -- {cmd}";
          drun-command = "uwsm-app -- {cmd}";
        };
      };

      programs.waybar.settings.main = {
        # ANCHOR waybar settings
        layer = "top";
        position = "top";
        modules-left = [
          "clock"
        ];
        modules-center = [

        ];
        modules-right = [
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
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
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
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        pulseaudio = {
          # "scroll-step": 1, // %, can be a float
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [
              ""
              ""
              " "
            ];
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
        gtk4.theme = null;
      };

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.05";
    };
  home-manager.backupFileExtension = "backup";
}
