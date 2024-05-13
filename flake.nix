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

      overlays = with inputs; [
#       snowfall-flake.overlays.default
      ];
      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
      ];

      

    };
}
