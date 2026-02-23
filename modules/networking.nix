{
  networking = {
    hostName = "nixos"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    firewall = {
      allowedTCPPorts = [
        53317
        22000
        25565
        4444
        3000
        18080
        37888
        3333
        10128
        21587
        21588
        3023
        3025
        8008
        8009
        27036
      ];
      allowedUDPPorts = [
        53317
        22000
        21027
        25565
        4444
        3000
        18080
        37888
        3333
        10128
        3022
        3024
        5353
        3478
        4379
        4380
      ];
      allowedUDPPortRanges = [
        {
          from = 32768;
          to = 61000;
        }
        {
          from = 27000;
          to = 27100;
        }
      ];
      # Or disable the firewall altogether.
      # enable = false;
    };
    nftables.enable = true;
  };
}
