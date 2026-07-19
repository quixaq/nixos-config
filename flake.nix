/*
  NixOS Configuration
  Copyright (C) 2026  Quixaq

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    sops-nix.url = "github:Mic92/sops-nix";
    qfetch.url = "github:quixaq/qfetch";
    pesde-nix.url = "github:quixaq/pesde-nix";
    nh.url = "github:nix-community/nh";
    panicshutdown.url = "github:quixaq/panicshutdown";
    trivalent-nix.url = "github:quixaq/trivalent-nix";
    # bookokrat.url = "github:bugzmanov/bookokrat";
    # zwift.url = "github:netbrain/zwift";
  };

  outputs =
    {
      lix-module,
      hjem,
      nixpkgs,
      nix-index-database,
      musnix,
      nix-flatpak,
      qfetch,
      pesde-nix,
      sops-nix,
      nh,
      panicshutdown,
      trivalent-nix,
      # bookokrat,
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
          (
            { pkgs, ... }:
            {
              environment.systemPackages = [
                panicshutdown.packages.${pkgs.system}.default
              ];
            }
          )
          musnix.nixosModules.musnix
          # zwift.nixosModules.zwift
          ./configuration.nix
          lix-module.nixosModules.default
          nix-index-database.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
          qfetch.nixosModules.default
          pesde-nix.nixosModules.default
          trivalent-nix.nixosModules.default
          # { environment.systemPackages = [ inputs.bookokrat.packages."x86_64-linux".default ]; }
          { programs.nix-index-database.comma.enable = true; }
          sops-nix.nixosModules.sops
          {
            nixpkgs.overlays = [ nh.overlays.default ];
          }
          {
            sops.defaultSopsFile = ./secrets/secrets.yaml;
            sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
            sops.secrets.git_signing_key = {
              owner = "quixaq";
              path = "/home/quixaq/.ssh/id_quixaq_signing";
            };
            sops.secrets.maloja_env = {
              owner = "root";
              path = "/run/secrets/maloja.env";
            };
            sops.secrets.searxng_env = {
              owner = "root";
              path = "/run/secrets/searxng.env";
            };
          }
          hjem.nixosModules.default
        ];
      };
    };
}
