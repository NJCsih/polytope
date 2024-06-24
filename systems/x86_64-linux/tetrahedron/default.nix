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
  polytope.system.nix.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;

  # TODO: What is this?
  #nix.package = inputs.lix-module.packages.x86_64-linux.default;


  # System Stuff ----------------------------------------------------------------------------------

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # "I have it enabled tho I don't remember quite
                                               # exactly what it does" - DarkKronicle

  # Zen is for desktop computing, so lower latency? I'm not gonna touch it
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable networkmanager for internet
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  # TODO: move this to modules/../nvim, but not sure why that doesnt work?
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Wallpapers TODO: Redo the whole wallpaper thing, they should probably be defined per-user
  environment.pathsToLink = [ "/share/wallpapers" ];


  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "tetrahedron"; # Define your hostname.

  # Define my user
  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "seat" ]; # What is seat for? Lemurs?
    initialPassword = "password";
    shell = pkgs.nushell;
  };

  # Virtualbox stuff
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "juliet" ];
  virtualisation.virtualbox.host.enableHardening = false;

  # Customization Stuff ----------------------------------------------------------------------------

  # Use custom fonts
  polytope = {
    desktop = {

      fonts = enabled;
    };
  };

  # enable kanata systemwide -- TODO: maybe make this a user thing?
  polytope.tools.kanata.enable = true;


  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages = #TODO: Group these properly
    (with pkgs; [

      # Apps
      blender
      firefox
      inkscape
      mumble
      nheko
      nushell
      pfetch
      qmk
      rofi
      virtualbox

      # School stuff
      jetbrains.idea-community

      # Tools
      borgbackup
      gimp
      git
      gparted
      keepassxc
      kitty
      neovim
        zls
        stylua
        lua-language-server
      networkmanager
      syncthing
      yazi

      # Utils
      acpi
      bandwhich
      bat
      bottom
      compsize # for showing size on disk of a file
      dust
      htop
      kanata
      libqalculate
      nixfmt-rfc-style
      nvtop
      pipes-rs
      polytope.poly
      pueue
      ripgrep
      tealdeer
      tomb
        gnupg
        pinentry
      wget
      wl-clipboard

      # System # TODO: Move to being only included by home-manager not here so they can be
      lemurs   # uninstalled if not needed for a setup
      picom
      swayfx   # I think the thing I'm trying to do in home-manager is what specilizations are fo
      wayland
      wpaperd

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
