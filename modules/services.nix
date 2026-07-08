{ config, pkgs, ... }:

{
  # SystemD
  systemd.settings.Manager = {
    KExecWatchdogSec = "5min";
    RebootWatchdogSec = "10min";
    RuntimeWatchdogSec = "30s";
    WatchdogDevice = "/dev/watchdog";
    CPUAffinity = "1-7";
  };

  # Docker
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Services
  hardware = {
    ckb-next = {
      enable = true;
      package = pkgs.ckb-next;
    };
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    steam-hardware.enable = true;
    cpu.x86.msr.enable = true;
    amdgpu.initrd.enable = true;
    amdgpu.opencl.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  systemd.services.snowflake-proxy = {
    wantedBy = [ "multi-user.target" ];
    after = [ "mullvad-daemon.service" ];
    wants = [ "mullvad-daemon.service" ];
    serviceConfig = {
      User = "root";
      ExecStart = [
        ""
        "${pkgs.mullvad-vpn}/bin/mullvad-exclude ${pkgs.snowflake}/bin/proxy"
      ];
    };
  };
  systemd.services.jitterentropy.serviceConfig = {
    SystemCallFilter = [
      "@system-service"
      "mlock"
    ];
    CapabilityBoundingSet = [ "CAP_IPC_LOCK" ];
    AmbientCapabilities = [ "CAP_IPC_LOCK" ];
  };
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  services = {
    hardware = {
      openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
        motherboard = "amd";
      };
    };
    resolved.enable = true;
    mullvad-vpn.enable = true;
    mullvad-vpn.package = pkgs.mullvad-vpn;
    tor = {
      enable = true;
      client.enable = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    dbus.enable = true;
    logrotate.enable = true;
    journald = {
      storage = "volatile";
      upload.enable = false;
      extraConfig = ''
        SystemMaxUse=500M
        SystemMaxFileSize=50M
      '';
    };
    jitterentropy-rngd.enable = (!config.boot.isContainer);
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"uwsm start hyprland-uwsm.desktop\"";
          user = "quixaq";
        };
      };
    };
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    mpd = {
      enable = true;
      user = "quixaq";
      settings = {
        music_directory = "/home/quixaq/Music";
        replaygain = "track";
        replaygain_preamp = 0;
        audio_output = [
          {
            type = "pipewire";
            name = "My PipeWire Output";
          }
          {
            type = "httpd";
            name = "httpd stream";
            encoder = "flac";
            port = 3939;
            bind_to_address = "127.0.0.1";
            always_on = "yes";
            format = "48000:24:2";
            max_clients = "0";
          }
        ];
      };
    };
  };
}
