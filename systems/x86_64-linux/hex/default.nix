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

  networking.firewall.enable = false; # TESTING

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

  # System Stuff ----------------------------------------------------------------------------------

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # [Re efi canTouchEfiVariables] "I have it enabled tho I don't remember quite
  # exactly what it does" - DarkKronicle -- I'm trusting them

  # Zen is for desktop computing, so lower latency? I'm not gonna touch it
  boot.kernelPackages = pkgs.linuxPackages_zen;

  environment.sessionVariables = rec {
    # fix for sway on this computer
    WLR_NO_HARDWARE_CURSORS = "1"; # Maybe I should try disabling it because it *slow*?
  };

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
  };

  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages =
    (with pkgs; [

      # Apps
      firefox
      nushell
      pfetch
      rofi

      # Work stuff
      thunderbird
      freerdp3
      krb5

      # Tools
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
      nix-tree
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
      gparted
      htop
      iotop
      kdePackages.dolphin
      libqalculate
      nixfmt-rfc-style
      nvtopPackages.full
      pipes-rs
      polytope.kanata # Latest version
      polytope.poly
      ripgrep
      tealdeer
      tomb
      gnupg # tomb dep
      pinentry # tomb dep
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
  services.xrdp.enable = true; # remote desktop service

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
