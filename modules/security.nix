{
  # ANCHOR security
  security = {
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

    # Replace sudo with doas
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          # Grant doas access specifically to your user
          users = [ "quixaq" ]; # <--- Only give access to your user
          # persist = true; # Convenient but less secure
          # noPass = true;    # Convenient but even less secure
          keepEnv = true; # Often necessary
          # Optional: You can also specify which commands they can run, e.g.:
          # cmd = "ALL"; # Allows running all commands (default if not specified)
          # cmd = "/run/current-system/sw/bin/nixos-rebuild"; # Only allow specific command
        }
      ];
    };
  };
  # breaks screen recording
  # environment.memoryAllocator.provider = "graphene-hardened";
}
