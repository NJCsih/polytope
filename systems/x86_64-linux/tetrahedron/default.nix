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

  # Make my laptop a router
  networking.nat = {
    enable = true;
    internalInterfaces = [ "eno0" ];
  };

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
  hardware.pulseaudio.enable = false;
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
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

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

  # Enable xdg portal
  #xdg.portal.enable = true;
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    #configPackages = with pkgs; [ gnome-keyring ];
    config = {
      common = {
        default = "*";
        #"org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  # Flatpak for rdp
  services.flatpak.enable = true;

  # Set custom udev rules for qmk
  #services.udev.extraRules = builtins.readFile ./qmk-udev-rules.txt;

  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "tetrahedron"; # Define your hostname.

  # Define my user
  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout" # for serial
      "input" # for kanata
      "networkmanager"
      "seat"
      "uinput" # for kanata
      "wireshark"
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
    tools.kerberosConfig.enable = false;
  };

  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages =
    (with pkgs; [

      # Apps
      blender
      brave
      firefox
      gwenview
      inkscape
      logisim-evolution
      mumble
      prusa-slicer
      nheko
      pfetch-rs
      qmk
      rofi
      snes9x

      # Programs
      nushell
      starship # for nushell
      mullvad-vpn
      virtualbox
      stellarium

      # School stuff
      jetbrains.idea-community
      openjdk

      # Cryptography
      # DarkKronicle's crypt-scripts are handled by a hm module
      age
      magic-wormhole-rs
      picocrypt-cli

      # Tools
      acpilight
      antimicrox # windows joy2key replacement -- this one's pretty cool
      audacity
      borgbackup
      gimp
      git
      gitoxide
      glava # visualizer, may change to a diff one at some point
      gparted
      grim
      keepassxc
      kitty
      lxqt.pavucontrol-qt
      neovim
      networkmanager
      nix-tree
      okular
      pdfarranger
      slurp
      stylua
      syncthing
      taskwarrior3
      tio # serial client
      mpv
      wireshark
      yazi

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
      pciutils
      pipes-rs
      polytope.kanata # Latest version
      polytope.lock
      polytope.poly
      ripgrep
      swww
      tcpdump
      tealdeer
      tomb
      gnupg # tomb dep
      pinentry # tomb dep
      unzip
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
    ++ [
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
        # Todo: make this managed on a per-user basis not per-system
        #wallpapers = ../../../modules/nixos/desktop/wallpapers/wallpapers.yml;
        wallpapers = ./wallpapers.yml;
      })
    ];

  programs.wireshark.enable = true; # set extra stuff for wireshark

  # Make steam work
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

      programs.sway = {
        enable = true;
        xwayland.enable = true;
      };

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

      # 'Enable' sway (set all the nice stuff)
      # should probably do this

      # Set pam to not have swaylock lock me out
      security.pam.services.swaylock = { };

      # Install sway specific stuff
      environment.systemPackages = (
        with pkgs;
        [
          swayfx
          waybar
          wayland
          wpaperd
          swaylock
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
