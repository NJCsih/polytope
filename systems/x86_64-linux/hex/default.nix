{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib.polytope) enabled;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
  ];


  # NixOS Stuff -----------------------------------------------------------------------------------

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable global settings in :
  #~/polytope/modules/nixos/system/nix/default.nix
  polytope.system.nix.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;


  # System Stuff ----------------------------------------------------------------------------------

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable entworkmanager for internet
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  # TODO: move this to modules/../nvim, but not sure why that doesnt work?
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Wallpapers TODO: Redo the whole wallpaper thing, they should probably be defined per-user
  environment.pathsToLink = [ "/share/wallpapers" ];


  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "hex"; # Define your hostname.

  # Define my user
  users.users.xray = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "password";
    shell = pkgs.nushell;
  };


  # Cusomization Stuff ----------------------------------------------------------------------------

  # Use custom fonts
  polytope = {
    desktop = {
      fonts = enabled;
    };
  };

  # enable kanata systemwide -- TODO: maybe make this a user thing?
  polytope.tools.kanata.enable = true;


  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages = #TODO: finish grouping these properly
    (with pkgs; [
      bat
      borgbackup
      bottom
      dust
      firefox
      gimp
      git
      gparted
      htop
      kitty
      libqalculate
      neovim
      networkmanager
      nushell
      nvtop
      pfetch
      pipes-rs
      ripgrep
      rofi
      syncthing
      tealdeer

      # Work stuff
      thunderbird
      taskwarrior

      # Utils
      tomb
        pinentry
        gnupg
      wget
      wl-clipboard
      keepassxc

      wayland
      yazi
      zls
    ])
    ++ ([
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
	# Todo: make this managed on a per-user basis not per-system
        #wallpapers = ../../../modules/nixos/desktop/wallpapers/wallpapers.yml;
        wallpapers = ./wallpapers.yml;
      })
    ]);

  system.stateVersion = "24.05"; # Don't touch
}
