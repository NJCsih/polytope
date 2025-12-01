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

  # for bios updates
  services.fwupd.enable = true;

  # System Stuff ----------------------------------------------------------------------------------

  networking.hostName = "hexahedron"; # Define your hostname.

  # Add TLP for laptop power
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

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Wallpapers TODO: Redo the whole wallpaper thing, they should probably be defined per-user
  environment.pathsToLink = [ "/share/wallpapers" ];

  # udisk 2 nice for things, allows unprivileged users to mount
  services.udisks2.enable = true;

  # User Stuff ------------------------------------------------------------------------------------

   # make 'media' user which is in a group called media which has mpv and read permissions to /media
  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
      "input" # for kanata
      "networkmanager"
      "seat"
      "uinput" # for kanata
      "wireshark"
      "media" #for media dac permissions
    ];
    initialPassword = "password";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO/Gg0Y2x4jG7H4P4X6szZG0KHWSaiq6WcQJDZVcVKFd juliet@tetrahedron"
    ];
  };
#  users.groups.media = {};
#  users.users.media = {
#    isNormalUser = false;
#    isSystemUser = true;
#    group = "media";
#    extraGroups = [
#      #"seat" #what was this??
#      "input" # for kanata
#      "uinput" # for kanata
#      #"media" #for media dac permissions
#    ];
#    initialPassword = "password";
#    shell = pkgs.nushell;
#  };
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

      anki
      logisim-evolution
      rnote
      quartus-prime-lite

      tor-browser
      mullvad-browser

      qmk

      prismlauncher
      vcv-rack

      kdePackages.kdeconnect-kde

      # Laptop stuff
      acpilight
      acpi
      fwupd

      # Games
      #dwarf-fortress-full
      #dwarf-fortress-packages.themes.meph

      nomachine-client

      # horrible things
      wl-kbptr

      #nomachine-client

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

    services.flatpak = {
      enable = true;
      update.auto.enable = true;
      packages = [
        "org.kicad.KiCad"
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
      PermitRootLogin = "no";
    };
  };
  services.fail2ban.enable = true;

  programs.wireshark.enable = true; # set extra stuff for wireshark

  # 56412 is for ssh
  # 22000 is for syncthing
  # 2465, 2993 is for email
  networking.firewall.allowedTCPPorts = [ 56412 22000 2465 2993 ];
  networking.firewall.allowedUDPPorts = [ 22000 ];
  # testing for netbird/kdeconnect:
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

  # sops
  # sops = {
  #   age.keyFile = "/var/lib/sops/sops.age.key";
  #   defaultSopsFile = ./secrets/secrets.yaml;
  #   defaultSopsFormat = "yaml";
  # };

  # netbird
  services.netbird.enable = true;

  # mullvad (false by default, enabled by specialisation)
  #services.mullvad-vpn.enable = false;
  #services.mullvad-vpn.package = pkgs.mullvad-vpn;

  programs.kdeconnect.enable = true;
  home-manager.users.juliet = {  # Some cursed shenangains to make a home manager scope,
    services.kdeconnect = {      # Curtsey of darkkronicle's evil genius
      enable = true;
      indicator = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };


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
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --time --cmd '${lib.getExe config.programs.sway.package} --unsupported-gpu'";
        user = "greeter";
      };
    };
  };

  specialisation.vpn-soft.configuration = {
    polytope.network.dnscrypt.enable = lib.mkOverride 150 false;
    # polytope.network.netbird.enable = lib.mkOverride 150 false;
    # services.netbird.enable = lib.mkOverride 150 false;
    services.mullvad-vpn.enable = lib.mkOverride 150 true;
    services.mullvad-vpn.package = lib.mkOverride 150 pkgs.mullvad-vpn;

    # Firewall rule, so that netbird will be run through netbird and not die
    networking.nftables.tables."mullvad-netbird" = lib.mkOverride 150 (let
        excludedIps = "100.114.0.0/16";
    in {
      name = "mullvad-netbird";
      enable = true;
      family = "inet";
      content = ''
        chain outgoing {
            type route hook output priority -100; policy accept;
            ip daddr ${excludedIps} oifname "wt0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        }
        chain allow-incoming {
            type filter hook input priority -100; policy accept;
            iifname "wt0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        }
      '';
    });

    home-manager.users.juliet = {  # Some cursed shenangains to make a home manager scope,
      programs.firefox.profiles.main.arkenfox."0700".enable = lib.mkOverride 150 false;
      programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".enable = true; # Set this setting
      programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".value = lib.mkOverride 150 0; # use default resolver
    };
  };

  specialisation.vpn-hard.configuration = {
    polytope.network.dnscrypt.enable = lib.mkOverride 150 false;
    polytope.network.netbird.enable = lib.mkOverride 150 false;
    services.netbird.enable = lib.mkOverride 150 false;
    services.mullvad-vpn.enable = lib.mkOverride 150 true;
    services.mullvad-vpn.package = lib.mkOverride 150 pkgs.mullvad-vpn;
    home-manager.users.juliet = {  # Some cursed shenangains to make a home manager scope,
      programs.firefox.profiles.main.arkenfox."0700".enable = lib.mkOverride 150 false;
      programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".enable = true; # Set this setting
      programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".value = lib.mkOverride 150 0; # use default resolver
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}
