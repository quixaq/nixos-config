{ inputs, pkgs, lib, ... }:

{
  # ANCHOR security
  security = {
    wrappers.panicshutdown = {
      source = "${inputs.panicshutdown.packages.${pkgs.system}.default}/bin/panicshutdown";
      setuid = true;
      owner = "root";
      group = "root";
    };
    wrappers.mullvad-exclude.setuid = lib.mkForce false;
    pam.services.login.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
    protectKernelImage = true;
    rtkit.enable = true;
    forcePageTableIsolation = true;
    allowUserNamespaces = true;
    auditd.enable = true;
    audit.enable = true;
    audit.rules = [
    ];

    # Disable sudo
    sudo.enable = false;
  };
  # breaks screen recording
  # environment.memoryAllocator.provider = "graphene-hardened";
}
