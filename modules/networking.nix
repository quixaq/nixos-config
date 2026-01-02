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
        37889
        37888
        18080
        3333
        3000
      ];
      allowedUDPPorts = [
        53317
        22000
        21027
        25565
        37889
        37888
        18080
        3333
        3000
      ];
      # Or disable the firewall altogether.
      # enable = false;
    };
    nftables.enable = true;
  };
}
