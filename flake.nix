{
  description = "Mono-configuration for system";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #   snowfall-flake = {
    #     url = "github:snowfallorg/flake";
    #     inputs.nixpkgs.follows = "nixpkgs";
    #   };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
