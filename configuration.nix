# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Import home-manager
    inputs.home-manager.nixosModules.home-manager
    # Import modules
    ./modules/boot.nix
    ./modules/home-manager.nix
    ./modules/packages.nix
    ./modules/networking.nix
    ./modules/services.nix
    ./modules/localization.nix
    ./modules/users.nix
    ./modules/nix.nix
    ./modules/security.nix
    ./modules/bash.nix
    ./modules/fs.nix
  ];
}
