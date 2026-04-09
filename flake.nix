{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    musnix.url = "github:musnix/musnix";
    qfetch.url = "github:quixaq/qfetch";
    #zwift.url = "github:netbrain/zwift";
  };

  outputs =
    {
      self,
      lix-module,
      lix,
      nixpkgs,
      nix-index-database,
      musnix,
      qfetch,
      #      zwift,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          musnix.nixosModules.musnix
          # zwift.nixosModules.zwift
          ./configuration.nix
          lix-module.nixosModules.default
          nix-index-database.nixosModules.default
          qfetch.nixosModules.default
          { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };
}
