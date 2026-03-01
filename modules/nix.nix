{ inputs, ... }:

{
  # Enable daily garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  # Enable running optimizer on build
  nix.settings.auto-optimise-store = true;

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "auto-allocate-uids"
    "cgroups"
    "ca-derivations"
    "no-url-literals"
  ];

  # system
  system = {
    autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [ "-L" ];
      dates = "daily";
      persistent = true;
      allowReboot = false;
      runGarbageCollection = true;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "25.05"; # Did you read the comment?
  };
}
