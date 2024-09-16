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
  hardware.pulseaudio.enable = false;

  # System Stuff ----------------------------------------------------------------------------------

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # [Re efi canTouchEfiVariables] "I have it enabled tho I don't remember quite
  # exactly what it does" - DarkKronicle -- I'm trusting them

  # Zen is for desktop computing, so lower latency? I'm not gonna touch it
  boot.kernelPackages = pkgs.linuxPackages_zen;

  #environment.sessionVariables = rec {
  # fix for sway on this computer
  #WLR_NO_HARDWARE_CURSORS = "1"; # Maybe I should try disabling it because it *slow*?
  #};

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
        default = [
          "gtk"
          "wlr"
          "kde"
        ];
        #"org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  # Flatpak for rdp
  services.flatpak.enable = true;

  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "hex"; # Define your hostname.

  # Define my user
  users.users.xray = {
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

  # Customization Stuff ----------------------------------------------------------------------------

  # Use custom fonts
  polytope = {
    desktop = {
      fonts = enabled;
    };
    tools.kerberosConfig.enable = true;
  };

  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages =
    (with pkgs; [

      # Apps
      firefox
      nushell
      starship # for nushell
      pfetch
      rofi

      # Cryptography
      age
      magic-wormhole-rs
      picocrypt-cli


      # Tools
      borgbackup
      freerdp3
      gimp
      git
      gitoxide
      gparted
      grim
      keepassxc
      kitty
      kmix
      krb5
      lua-language-server
      neovim
      networkmanager
      nix-tree
      okular
      slurp
      stylua
      syncthing
      tio # serial client
      vlc
      wireshark
      yazi
      zls

      # Utils
      bandwhich
      bat
      bottom
      compsize # for showing size on disk of a file
      dust
      htop
      iotop
      kdePackages.dolphin
      libqalculate
      nixfmt-rfc-style
      nvtopPackages.full
      pciutils
      pipes-rs
      polytope.kanata # Latest version
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

    ])
    ++ ([
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
        # Todo: make this managed on a per-user basis not per-system
        #wallpapers = ../../../modules/nixos/desktop/wallpapers/wallpapers.yml;
        wallpapers = ./wallpapers.yml;
      })
    ]);

  programs.wireshark.enable = true; # set extra stuff for wireshark

  # enable xrdp stuff
  services.xrdp.enable = true; # remote desktop service
  services.xrdp.defaultWindowManager = "${pkgs.sway}/bin/sway";
  services.xrdp.openFirewall = true;

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
