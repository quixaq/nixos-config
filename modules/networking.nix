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
      ];
      # Or disable the firewall altogether.
      # enable = false;
    };
    nftables.enable = true;
  };
}
