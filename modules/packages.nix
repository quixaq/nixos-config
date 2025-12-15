{ pkgs, lib, ... }:

let
	old-stable = import <nixos-old-stable> {
			system = pkgs.system;
			config = {
				allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [];
			};
	};
	/*stable = import <nixos-stable> {
			system = pkgs.system;
			config = {
				allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [];
			};
	};*/
in
{
	# ANCHOR overlays
	nixpkgs.overlays = [
		(final: prev: {
			ckb-next = prev.ckb-next.overrideAttrs (old: {
				buildInputs = (old.buildInputs or []) ++ [ old-stable.libsForQt5.libdbusmenu ];
			});
		})
	];
	# ANCHOR packages
	environment.systemPackages = with pkgs; [
		# Hypr ecosystem
		hyprlock
		hypridle
		hyprpicker
		hyprshot
		hyprlang
		hyprutils
		hyprwayland-scanner

		# CLI's
		vim
		fastfetch
		mpc
		android-tools
		p7zip
		gamemode
		pipes
		playerctl
		yt-dlp
		htop
		git
		lm_sensors
		mat2
		p2pool
		xmrig
		ydotool
		sbctl
		niv
		jrnl
		ffmpeg
		flac
		ollama

		# Graphical Apps
		kitty
		xfce.thunar
		rofi
		chromium
		tor-browser
		winetricks
		file-roller
		lutris
		protonup-qt
		ckb-next
		feh
		mpv
		gnome-system-monitor
		gimp-with-plugins
		libreoffice
		legcord
		obs-studio
		audacity
		filezilla

		# IDEs
		vscodium
		godot
		neovim

		# LSPs
		nixd

		# Themes
		rose-pine-hyprcursor
		gnome-themes-extra

		# Utils
		wine
		dunst
		smile
		kernel-hardening-checker
		wl-clipboard
		gnupg
		go
		zulu
		monero-gui
		python315
		oversteer
		gcc
		nodejs_24
		pnpm
		wget
		dotnet-sdk_9
		clipse
		iftop
		cava
		gleam
		beam28Packages.erlang
		xdg-dbus-proxy
		xdg-desktop-portal
		xdg-desktop-portal-gtk
		xdg-desktop-portal-gnome

		# Games
		prismlauncher
		osu-lazer-bin
	];
	# ANCHOR xdg
	# xdg.portal.xdgOpenUsePortal = true;
	xdg.portal.enable = true;
	xdg.portal.xdgOpenUsePortal = true;
	xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-gnome];
	xdg.portal.config = {
		common.default = [ "gtk" "gnome" ];
		hyprland = {
			default = [ "gtk ""gnome" ];
			"org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
			"org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
		};
	};
	xdg.portal.configPackages = [ pkgs.gnome-session ];
	xdg.mime.defaultApplications = {
		"text/html" = "chromium.desktop";
		"x-scheme-handler/http" = "chromium.desktop";
		"x-scheme-handler/https" = "chromium.desktop";
	};
	programs.dconf.enable = true;
	# ANCHOR fonts
	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-color-emoji
		fira-code
		fira-code-symbols
		font-awesome
		roboto
		texlivePackages.opensans
		material-symbols
		roboto
		noto-fonts-cjk-sans
		noto-fonts-cjk-serif
	];

	# Hyprland
	programs.hyprland.enable = true;
	programs.hyprland.withUWSM = true;
	# hint Electron apps to use Wayland:
	environment.sessionVariables.NIXOS_OZONE_WL = "1";

	# Steam
	programs.steam.enable = true;

	# GNUPG
	programs.gnupg.agent = {
		enable = true;
	};

	# allowUnfreePredictate
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"steam"
		"steam-original"
		"steam-unwrapped"
		"steam-run"
		"osu-lazer-bin"
	];
}
