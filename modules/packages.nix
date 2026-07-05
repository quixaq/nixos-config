{
  pkgs,
  lib,
  ...
}:

let
  lockScript = pkgs.writeShellScriptBin "lock-session" ''
    ! ${pkgs.uutils-procps}/bin/pgrep -x hyprlock > /dev/null && (${pkgs.mpc}/bin/mpc status | grep -q '\[playing\]' ; playing=$? ; ${pkgs.mpc}/bin/mpc pause ; ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 ; ${pkgs.hyprlock}/bin/hyprlock ; ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ; if [ "$playing" -eq 0 ] ; then ${pkgs.mpc}/bin/mpc play ; fi)
  '';

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

  findutils-name =
    "finduutils"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (builtins.stringLength pkgs.findutils.version)
    );

  procps-name =
    "procps"
    + builtins.concatStringsSep "" (
      builtins.genList (_: "_") (
        (builtins.stringLength pkgs.procps.name) - (builtins.stringLength "procps")
      )
    );
in
{
  # ANCHOR packages
  environment.systemPackages = with pkgs; [
    # Hypr ecosystem
    hyprlock
    hyprpicker
    hyprshot
    hyprlang
    hyprutils
    hyprwayland-scanner

    # CLIs
    trash-cli
    vim
    mpc
    loudgain
    android-tools
    p7zip
    gamemode
    pipes
    cmatrix
    asciiquarium
    cava
    playerctl
    yt-dlp
    iftop
    git
    gh
    git-annex
    lm_sensors
    mat2
    xmrig
    p2pool
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
    yetris
    libsecret
    google-lighthouse
    yabridgectl

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
    legcord
    stoat-desktop
    ungoogled-chromium
    winetricks
    file-roller
    protonup-qt
    ckb-next
    openrgb-with-all-plugins
    feh
    mpv
    gnome-system-monitor
    gimp-with-plugins
    krita
    obs-studio
    audacity
    filezilla
    localsend
    seahorse
    kdePackages.kdenlive
    calibre
    reaper
    sweethome3d.application

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
    luau-lsp
    lua-language-server
    package-version-server

    # Themes
    rose-pine-hyprcursor
    gnome-themes-extra

    # Utils
    rojo
    lune
    wally
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
    nh
    nvd
    nix-output-monitor
    sops
    yabridge
    zenity
    swaybg
    lockScript
    waybar
    zsh-powerlevel10k
    crates-tui
    bpm-tools

    # Audio Plugins
    surge-xt

    # Games
    prismlauncher
    osu-lazer-bin
    heroic
    lutris
    faugus-launcher
  ];
  # flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "com.github.Matoking.protontricks"
      "io.github.Soundux"
      "org.vinegarhq.Sober"
      "org.vinegarhq.Vinegar"
      "org.musicbrainz.Picard"
      "com.usebottles.bottles"
    ];
  };
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
    twitter-color-emoji
  ];

  # Hyprland
  programs.hyprland.enable = true;
  #programs.hyprland.portalPackage = "${pkgs.stdenv.hostPlatform.system}".xdg-desktop-portal-hyprland;
  programs.hyprland.withUWSM = true;
  # hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Enable hyprlock
  programs.hyprlock.enable = true;

  # Steam
  programs.steam.enable = true;

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # GNUPG
  programs.gnupg.agent = {
    enable = true;
  };

  # NH
  programs.nh = {
    enable = true;
    flake = "/home/quixaq/NixOS";
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 10";
      dates = "daily";
    };
  };

  # Zwift
  #programs.zwift = {
  #  enable = true;
  #  image = "docker.io/netbrain/zwift";
  #  containerTool = "docker";
  #  containerExtraArgs = "";
  #  zwiftWorkoutDir = "/home/quixaq/zwift/workouts";
  #  zwiftActivityDir = "/home/quixaq/zwift/activities";
  #  zwiftLogDir = "/home/quixaq/zwift/logs";
  #  zwiftScreenshotsDir = "/home/quixaq/zwift/screenshots";
  #  zwiftUid = "1000";
  #  zwiftGid = "1000";
  #  vgaDeviceFlag = "--gpus=all";
  #};

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

    # procps
    {
      # applications
      oldDependency = pkgs.procps;
      newDependency = pkgs.symlinkJoin {
        # Make the name length match so it builds
        name = procps-name;
        paths = [ pkgs.uutils-procps ];
      };
    }
  ];

  # Overlays
  nixpkgs.overlays = [
    (final: prev: {
      linux_xanmod_stable = prev.linux_xanmod_stable.override {
        stdenv = pkgs.clangStdenv;
        buildLLVM = true;
        argsOverride = {
          NIX_CFLAGS_COMPILE = "-march=znver4 -mtune=znver4";
        };
      };
    })
  ];

  # ANCHOR zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "";
    };
    interactiveShellInit = ''
      source ~/.zshrc
    '';
  };
  environment.variables.P10K_PATH = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  # ANCHOR allowUnfreePredictate
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "osu-lazer-bin"
      "reaper"
    ];
}
