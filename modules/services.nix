{ config, pkgs, ... }:

{
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

  services = {
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
  };
}
