{
  description = "Mono-configuration for system";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nazarick = {
      url = "github:DarkKronicle/nazarick";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    #   snowfall-flake = {
    #     url = "github:snowfallorg/flake";
    #     inputs.nixpkgs.follows = "nixpkgs";
    #   };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          meta = {
            name = "polytope";
            title = "The universe of shapes";
          };
          namespace = "polytope";
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        # permittedUnsecurePackages = [];
      };

      systems.modules.nixos = with inputs; [ home-manager.nixosModules.home-manager ];
    };
}
