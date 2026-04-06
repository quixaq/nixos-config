{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    musnix.url = "github:musnix/musnix";
    qfetch.url = "github:quixaq/qfetch";
    pesde-nix.url = "github:lukadev-0/pesde-nix";
    #zwift.url = "github:netbrain/zwift";
  };

  outputs =
    {
      self,
      nixpkgs,
      musnix,
      qfetch,
      pesde-nix,
      #      zwift,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit pesde-nix;
        };
        modules = [
          musnix.nixosModules.musnix
          # zwift.nixosModules.zwift
          ./configuration.nix
          qfetch.nixosModules.default

        ];
      };
    };
}
