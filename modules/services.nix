{ config, pkgs, ... }:

{
  # PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."92-no-stutter" = {
      "context.properties" = {
        "default.clock.rate" = 96000;
        "default.clock.allowed-rates" = [
          32000
          44100
          48000
          96000
        ];
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 2048;
        "default.clock.max-quantum" = 4096;
        "default.thread.prio" = 80;
      };
    };
    extraConfig.pipewire-pulse."92-low-latency" = {
      "context.properties" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = { };
        }
      ];
      "pulse.properties" = {
        "pulse.min.quantum" = "2048/48000";
        "pulse.max.quantum" = "4096/48000";
      };
    };
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
  hardware.ckb-next = {
    enable = true;
    package = pkgs.ckb-next;
  };
  hardware.bluetooth.enable = false;
  hardware.cpu.x86.msr.enable = true;
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.opencl.enable = true;

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
  services = {
    flatpak.enable = true;
    resolved.enable = true;
    mullvad-vpn.enable = true;
    mullvad-vpn.package = pkgs.mullvad-vpn;
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
  };
}
