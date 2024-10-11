{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
in
# inherit (lib.polytope) enabled;
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./hardware.nix
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
  #polytope.system.nix.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;

  # System Stuff ----------------------------------------------------------------------------------

  # Use the systemd-boot EFI boot loader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # [Re efi canTouchEfiVariables] "I have it enabled tho I don't remember quite
  # exactly what it does" - DarkKronicle -- I'm trusting them
  #boot.loader.grub.device = "/dev/disk/by-uuid/F75B-4E87"; # or "nodev" for efi only
  #boot.loader.grub.useOSProber = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.

  boot.loader.systemd-boot.enable = true;

  # Zen is for desktop computing, so lower latency? I'm not gonna touch it
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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

  networking.hostName = "hex"; # Define your hostname.

  # Define my user
  users.users.xray = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "password";
    shell = pkgs.nushell;
  };

  # Customization Stuff ----------------------------------------------------------------------------

  # Use custom fonts
  # polytope = {
  #   desktop = {
  #     fonts = enabled;
  #   };
  # };

  # enable kanata systemwide -- TODO: maybe make this a user thing?
  # polytope.tools.kanata.enable = true;

  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages = (
    with pkgs;
    [

      # Apps
      firefox
      nushell
      pfetch-rs
      rofi

      # Work stuff
      thunderbird

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
      bandwhich
      bat
      bottom
      compsize # for showing size on disk of a file
      dust
      htop
      kanata
      keepassxc
      libqalculate
      nixfmt-rfc-style
      nvtopPackages.full
      pipes-rs
      # polytope.poly
      ripgrep
      tealdeer
      tomb
      gnupg # tomb dep
      pinentry # tomb dep
      wget
      wl-clipboard

    ]
  );
  # ])
  # ++ ([
  #   (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
  #     # Todo: make this managed on a per-user basis not per-system
  #     #wallpapers = ../../../modules/nixos/desktop/wallpapers/wallpapers.yml;
  #     wallpapers = ./wallpapers.yml;
  #   })
  # ]);

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
