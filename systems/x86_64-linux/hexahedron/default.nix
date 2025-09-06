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

  # Use encrypted dns resolving
  polytope.network.dnscrypt.enable = true;

  # Netbird settings and auto-restart timer
  polytope.network.netbird.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;

  # System Stuff ----------------------------------------------------------------------------------

  networking.hostName = "hexahedron"; # Define your hostname.

  # Add TIP for laptop power
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # Nobody understands this, I'm just trusting dark

  boot.loader.timeout = 60;

  # Zen is for desktop computing, so lower latency? I'm not gonna touch it
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

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

  # Set custom udev rules for qmk
  # TODO Pull the stm32 out of the bottom of the temp qmk rules file
  services.udev.extraRules = (builtins.readFile ./qmk-udev-rules.txt) +
  ''
    # Udev rules required for stm32 flashing
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", MODE="0666"
    SUBSYSTEM=="usb_device", ATTRS{idVendor}=="0483", MODE="0666"
  '';

  # Medium system level Stuff ------------------------------------------------------------------------------------

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Wallpapers TODO: Redo the whole wallpaper thing, they should probably be defined per-user
  environment.pathsToLink = [ "/share/wallpapers" ];

  # udisk 2 nice for things, allows unprivileged users to mount
  services.udisks2.enable = true;

  # Enable sound.

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [
      "input" # for kanata
      "networkmanager"
      "seat"
      "uinput" # for kanata
      "wheel"
      "wireshark"
    ]; # What is seat for? Lemurs? Vbox?
    initialPassword = "password";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO/Gg0Y2x4jG7H4P4X6szZG0KHWSaiq6WcQJDZVcVKFd juliet@tetrahedron"
    ];
  };
  environment.shells = [ pkgs.nushell ];

  # Virtualbox stuff
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "juliet" ];
  virtualisation.virtualbox.host.enableHardening = false;

  # Use gnome-keyring for secrets, keepass has been annoying, (It's like *finnneee* and kinda my fault)
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Customization Stuff ----------------------------------------------------------------------------

  # Use custom fonts
  polytope = {
    desktop = {
      fonts = enabled;
    };
  };

  # Systemwide Packages ---------------------------------------------------------------------------
  polytope.mypackages.enable = true;
  environment.systemPackages =
    (config.polytope.mypackages.base) ++
    (config.polytope.mypackages.extra) ++
    (config.polytope.mypackages.gui.base) ++
    (config.polytope.mypackages.gui.extra) ++
    (with pkgs; [

      # Specific to this system

      signal-desktop # yes it's a gross electron app

      neomutt # tui email client

      logisim-evolution # Circuit simulator

      tor-browser
      mullvad-browser

      qmk

      prismlauncher
      vcv-rack

      plasma5Packages.kdeconnect-kde

      # Laptop stuff
      acpilight
      acpi

      anki
      rnote

      quartus-prime-lite

      (proxmark3.override {
        withGui = false;
        withPython = true;
        withGeneric = true;
        withSmall = false;
      })

    ])
    ++ [
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
        wallpapers = ./wallpapers.yml;
      })
    ];

    # Flatpak for rdp and betterbird
    services.flatpak = {
      enable = true;
      update.auto.enable = true;
      packages = [
        "eu.betterbird.Betterbird"
      ];
    };

# Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 56412 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "juliet" ];
      UseDns = true;
      X11Forwarding = false;
      #PermitRootLogin = "no";
    };
  };
  services.fail2ban.enable = true;

  programs.wireshark.enable = true; # set extra stuff for wireshark

  # 56412 is for ssh
  # 22000 is for syncthing
  # 2465, 2993 is for email
  # 4242 is for nebula
  networking.firewall.allowedTCPPorts = [ 56412 22000 2465 2993 ];
  networking.firewall.allowedUDPPorts = [ 22000 ]; 

  # sops
#   sops = {
#     age.keyFile = "/var/lib/sops/sops.age.key";
#     defaultSopsFile = ./secrets/secrets.yaml;
#     defaultSopsFormat = "yaml";
#   };

  # netbird
  services.netbird.enable = true;

  programs.kdeconnect.enable = true;
  home-manager.users.juliet = {  # Some cursed shenangains to make a home manager scope,
    services.kdeconnect = {      # Curtsey of darkkronicle's evil genius
      enable = true;
      indicator = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };

  # mullvad
  #services.mullvad-vpn.enable = true;
  #services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # testing for netbird/kdeconnect:
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

  # Make steam work
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.sway = {
    package = pkgs.swayfx;
    enable = true;
    xwayland.enable = true;
    extraSessionCommands = ''
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=qt5ct
      export _JAVA_AWT_WM_NONREPARENTIMG=1
      export QT_QPA_PLATFORM=xcb
    '';
  };


  # Set pam to not have swaylock lock me out
  security.pam.services.swaylock = { };

  # Login manager:
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --time --cmd '${lib.getExe config.programs.sway.package} --unsupported-gpu'";
        user = "greeter";
      };
    };
  };

  specialisation.vpn.configuration = {
    polytope.network.dnscrypt.enable = lib.mkOverride 50 false;
    polytope.network.netbird.enable = lib.mkOverride 50 false;
    services.netbird.enable = lib.mkOverride 50 false;
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;
    # Todo: write a nix crime to set the home manager option of what dns firefox uses
    home-manager.users.juliet = {  # Some cursed shenangains to make a home manager scope,
      programs.firefox.profiles.main.arkenfox."0700".enable = lib.mkOverride 150 false;
      programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".enable = true; # Set this setting
      programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".value = lib.mkOverride 150 0; # use default resolver
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}

