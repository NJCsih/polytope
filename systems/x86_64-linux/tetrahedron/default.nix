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
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  # If you want to use JACK applications, uncomment this
  #  #jack.enable = true;
  #};

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

  # Set for Kanata/the sway keybind system
  hardware.uinput.enable = true;

  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "tetrahedron"; # Define your hostname.

  # Define my user
  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "uinput" # for kanata
      "input" # for kanata
      "seat"
      "wireshark"
      "dialout" # for serial
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

  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages =
    (with pkgs; [

      # Apps
      blender
      brave
      firefox
      inkscape
      logisim-evolution
      mumble
      nheko
      nushell
      pfetch
      qmk
      rofi
      snes9x
      virtualbox

      # School stuff
      jetbrains.idea-community
      openjdk
      jprofiler

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
      networkmanagerapplet
      slurp
      stylua
      syncthing
      tio # serial client
      vlc
      wireshark
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
      kdePackages.dolphin
      libqalculate
      networkmanagerapplet
      nixfmt-rfc-style
      nvtopPackages.full
      pipes-rs
      polytope.kanata # Latest version
      polytope.poly
      pueue
      ripgrep
      tealdeer
      tomb
      gnupg # tomb dep
      pinentry # tomb dep
      wget
      wl-clipboard
      wmname

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

  programs.wireshark.enable = true; # set extra stuff for wireshark

  # Make firefox work
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Specilizations for different display-managers -------------------------------------------------
  #   We'd technically want to just have different lemurs entries, but because plasma does too much
  #     I wanted to have the ability to enable/disable different programs completely from nix
  specialisation = {

    # Sway/Swayfx
    swayfx.configuration = {

      # Login manager:
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd '${pkgs.sway}/bin/sway --unsupported-gpu -c ~/.config/swayfx/config'";
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd '${pkgs.sway}/bin/sway --unsupported-gpu'";
            user = "greeter";
          };
        };
      };

      # Install sway specific stuff
      environment.systemPackages = (
        with pkgs;
        [
          swayfx
          waybar
          wayland
          wpaperd
        ]
      );
    };

    # Plasma 6
    plasma6.configuration = {

      # Enable plasma6
      services.desktopManager.plasma6.enable = true;

    };
  };

  system.stateVersion = "24.05"; # Don't touch
}
