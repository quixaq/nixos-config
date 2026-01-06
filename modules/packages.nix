{ pkgs, lib, ... }:

let
  old-stable = import <nixos-old-stable> {
    system = pkgs.system;
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
    };
  };
  /*
    stable = import <nixos-stable> {
    			system = pkgs.system;
    			config = {
    				allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [];
    			};
    	};
  */

  coreutils-full-name =
    "coreuutils-full"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (builtins.stringLength pkgs.coreutils-full.version)
    );

  coreutils-name =
    "coreuutils"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (builtins.stringLength pkgs.coreutils.version)
    );

  /*
    findutils-name =
    "finduutils"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (builtins.stringLength pkgs.findutils.version)
    );
  */

  /*
    diffutils-name =
    "diffuutils"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (builtins.stringLength pkgs.diffutils.version)
    );
  */
in
{
  # ANCHOR overlays
  nixpkgs.overlays = [
    (final: prev: {
      ckb-next = prev.ckb-next.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ old-stable.libsForQt5.libdbusmenu ];
      });
    })
  ];
  # ANCHOR packages
  environment.systemPackages = with pkgs; [
    # Hypr ecosystem
    hyprlock
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
    cmatrix
    cava
    playerctl
    yt-dlp
    iftop
    git
    lm_sensors
    mat2
    xmrig
    ydotool
    sbctl
    efibootmgr
    ffmpeg
    flac
    ollama
    pulseaudio
    steghide
    yazi
    hyperfine
    libsecret

    # GNU coreutils replacements
    htop
    eza
    fd
    ripgrep
    bat
    dust
    bottom
    procs
    tealdeer

    # Graphical Apps
    kitty
    thunar
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
    obs-studio
    audacity
    filezilla
    localsend

    # IDEs
    godot
    neovim
    zed-editor

    # LSPs
    nixd
    nil
    rust-analyzer
    rustfmt
    clippy

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
    gleam
    beam28Packages.erlang
    cargo
    rustc
    xdg-dbus-proxy
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-shana
    pavucontrol

    # Games
    prismlauncher
    osu-lazer-bin
  ];
  # ANCHOR xdg
  # xdg.portal.xdgOpenUsePortal = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-shana
    ];
    config.common.default = "*";
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
    nerd-fonts.jetbrains-mono
  ];

  # Hyprland
  programs.hyprland.enable = true;
  #programs.hyprland.portalPackage = "${pkgs.stdenv.hostPlatform.system}".xdg-desktop-portal-hyprland;
  programs.hyprland.withUWSM = true;
  # hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Steam
  programs.steam.enable = true;

  # GNUPG
  programs.gnupg.agent = {
    enable = true;
  };

  # ANCHOR replaceDependencies
  system.replaceDependencies.replacements = [
    # coreutils
    {
      # system
      oldDependency = pkgs.coreutils-full;
      newDependency = pkgs.symlinkJoin {
        # Make the name length match so it builds
        name = coreutils-full-name;
        paths = [ pkgs.uutils-coreutils-noprefix ];
      };
    }
    {
      # applications
      oldDependency = pkgs.coreutils;
      newDependency = pkgs.symlinkJoin {
        # Make the name length match so it builds
        name = coreutils-name;
        paths = [ pkgs.uutils-coreutils-noprefix ];
      };
    }
    /*
      # findutils
      {
        # applications
        oldDependency = pkgs.findutils;
        newDependency = pkgs.symlinkJoin {
          # Make the name length match so it builds
          name = findutils-name;
          paths = [ pkgs.uutils-findutils ];
        };
      }
    */
    /*
      # diffutils
      {
        # applications
        oldDependency = pkgs.diffutils;
        newDependency = pkgs.symlinkJoin {
          # Make the name length match so it builds
          name = diffutils-name;
          paths = [ pkgs.uutils-diffutils ];
        };
        }
    */
    # disabled due to breaking whole diffutils
  ];

  # ANCHOR allowUnfreePredictate
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "osu-lazer-bin"
    ];
}
