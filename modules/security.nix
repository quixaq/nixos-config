{
  inputs,
  pkgs,
  ...
}:

{
  # ANCHOR security
  security = {
    wrappers.panicshutdown = {
      source = "${inputs.panicshutdown.packages.${pkgs.system}.default}/bin/panicshutdown";
      setuid = true;
      owner = "root";
      group = "root";
    };
    pam.services.login.enableGnomeKeyring = true;
    pam.services.greetd.enableGnomeKeyring = true;
    protectKernelImage = true;
    rtkit.enable = true;
    forcePageTableIsolation = true;
    allowUserNamespaces = true;
    allowSimultaneousMultithreading = false;
    virtualisation.flushL1DataCache = "always";
    apparmor.enable = true;
    apparmor.killUnconfinedConfinables = true;
    apparmor.packages = [
      pkgs.apparmor-profiles
    ];
    apparmor.policies = {
      "bin.ping" = {
        state = "enforce";
        profile = builtins.readFile "${pkgs.apparmor-profiles}/etc/apparmor.d/bin.ping";
      };
      "usr.sbin.mdnsd" = {
        state = "enforce";
        profile = builtins.readFile "${pkgs.apparmor-profiles}/etc/apparmor.d/usr.sbin.mdnsd";
      };
      fusermount3 = {
        state = "enforce";
        profile = builtins.readFile "${pkgs.apparmor-profiles}/etc/apparmor.d/fusermount3";
      };
      wg = {
        state = "enforce";
        profile = builtins.readFile "${pkgs.apparmor-profiles}/etc/apparmor.d/wg";
      };
      zgrep = {
        state = "enforce";
        profile = builtins.readFile "${pkgs.apparmor-profiles}/etc/apparmor.d/zgrep";
      };
    };
    auditd.enable = true;
    audit.enable = true;
    audit.rules = [
    ];

    # Disable sudo
    sudo.enable = false;
  };
}
