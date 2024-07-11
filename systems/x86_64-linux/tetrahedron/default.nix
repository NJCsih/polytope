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
  boot.loader.efi.canTouchEfiVariables = true;
  # [Re efi canTouchEfiVariables] "I have it enabled tho I don't remember quite
  # exactly what it does" - DarkKronicle -- I'm trusting them

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "tetrahedron"; # Define your hostname.

  # Define my user
  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "seat"
    ]; # What is seat for? Lemurs? Vbox?
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
  environment.systemPackages =
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
      snes9x
      steam
      virtualbox

      # School stuff
      jetbrains.idea-community
      openjdk

      # Tools
      audacity
      borgbackup
      gimp
      git
      gparted
      grim
      keepassxc
      kitty
      kmix
      lua-language-server
      neovim
      networkmanager
      slurp
      stylua
      syncthing
      vlc
      yazi
      zls

      # Utils
      acpi
      bandwhich
      bat
      bottom
      compsize # for showing size on disk of a file
      dust
      htop
      iotop
      kanata
      kdePackages.dolphin
      libqalculate
      nixfmt-rfc-style
      nvtopPackages.full
      pipes-rs
      polytope.poly
      pueue
      ripgrep
      tealdeer
      tomb
      gnupg # tomb dep
      pinentry # tomb dep
      wget
      wl-clipboard

      # myPackages
      #packages.system-wallpapers.override {
      #polytope.wallpapers.override {
      #     polytope.wallpapers
      #wappapers = ./wallpapers.yml;
      #}

    ])
    ++ ([
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
        # Todo: make this managed on a per-user basis not per-system
        #wallpapers = ../../../modules/nixos/desktop/wallpapers/wallpapers.yml;
        wallpapers = ./wallpapers.yml;
      })
    ]);

  # Specilizations for different display-managers -------------------------------------------------
  #   We'd technically want to just have different lemurs entries, but because plasma does too much
  #     I wanted to have the ability to enable/disable different programs completely from nix
  specialisation = {

    # Sway/Swayfx
    swayfx.configuration = {
      # Lemurs boot entry for sway
      # Sway should handle everything else, and home-manager handles it's (and other's) configs
      environment.etc."lemurs/wayland/Sway.sh".source = pkgs.writeTextFile {
        name = "lemursSwayEntry";
        text = ''
          #! /bin/sh
          exec sway --unsupported-gpu
        '';
        executable = true;
      };

      # Install sway specific stuff
      environment.systemPackages = (
        with pkgs;
        [
          swayfx
          lemurs
          wayland
          wpaperd
          # Enable lemurs here so it handles the greeter
          # Will need to edit that startup systemd task here
        ]
      );
    };

    # Plasma 6
    plasma6.configuration = {

      # Enable plasma6
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
