{
  description = "Mono-configuration for system";

  inputs = {

    #---------------------------------------------------------------------------
    # Primary inputs:

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #---------------------------------------------------------------------------
    # General inputs:

    nazarick = {
      url = "github:DarkKronicle/nazarick";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #---------------------------------------------------------------------------
    # [Application] Specific inputs:

    # Neovim inputs:
    nvim-cats = { # Make nvim *perfectly* isolated to it's own flake
      url = "github:NJCsih/nvim-nixCats";
    };

    # Firefox:
    firefox-arkenfox = {
      url = "github:DarkKronicle/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blocklist = {
      url = "github:hagezi/dns-blocklists";
      flake = false;
    };

    # For jj in prompt
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plasma manager:
    #TODO: Check if this still works? I havent ran plasma in a *while*
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Darkly for qt theming
    darkly = {
      url = "github:Bali10050/Darkly";
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
        permittedInsecurePackages = [ "olm-3.2.16" ];
      };

      # https://github.com/snowfallorg/lib/issues/79#issuecomment-2221697884
      # Random code excerpt in an unrelated github issue comment, thank you for the seemingly undocumented syntax (but probably skill issue on my part) :p
      homes.modules = [
        inputs.firefox-arkenfox.hmModules.arkenfox
      ];

      systems.modules.nixos = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };
}
