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

  # Use encrypted dns resolving
  polytope.network.dnscrypt.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
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
  boot.loader.efi.canTouchEfiVariables = true;
  # [Re efi canTouchEfiVariables] "I have it enabled tho I don't remember quite
  # exactly what it does" - DarkKronicle -- I'm trusting them

  boot.loader.timeout = 0;

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
  # TODO Pull the stm32 out of the bottom of the temp qmk rules file
  services.udev.extraRules = (builtins.readFile ./qmk-udev-rules.txt) +
  ''
    # Udev rules required for stm32 flashing
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", MODE="0666"
    SUBSYSTEM=="usb_device", ATTRS{idVendor}=="0483", MODE="0666"
  '';

  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "tetrahedron"; # Define your hostname.

  # Define my user
  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input" # for kanata
      "uinput" # for kanata
      "networkmanager"
      "seat"
      "wireshark"
    ]; # What is seat for? Lemurs? Vbox?
    initialPassword = "password";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBlXd+xhJKsXh7ssfNCO+JdAPf1gh62aN/xqqi4aSFC" # voxel
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJOUaZUx+doReFTwnb486qFA8iz4tIfm7lD2qXjbUqb" # xray
    ];
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
  polytope.mypackages.enable = true;
  environment.systemPackages =
    (config.polytope.mypackages.base) ++
    (config.polytope.mypackages.extra) ++
    (config.polytope.mypackages.gui.base) ++
    (config.polytope.mypackages.gui.extra) ++
    (with pkgs; [

      # Specific to this system

      signal-desktop # yes it's a gross electron app

      logisim-evolution # Circuit simulator

      nvtopPackages.full # show nvidia usage info

      qmk

      acpilight
      acpi

      antimicrox # windows joy2key replacement -- this one's pretty cool

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
  # 4242 is for nebula
  networking.firewall.allowedTCPPorts = [ 56412 22000 ];
  networking.firewall.allowedUDPPorts = [ 4242 22000 ]; 

  services.nebula.networks.mesh = {
    enable = true;
    isLighthouse = false;
    cert = "/etc/nebula/tetrahedron.crt";
    key = "/etc/nebula/tetrahedron.key";
    ca = "/etc/nebula/ca.crt";
    staticHostMap = {
      "192.168.100.1" = [
        "xxx.xxx.xxx.xxx:4242" # This is the default addr from the nebula readme, I need to replace it with sops
      ];
    };
    lighthouses = [ "192.168.100.1" ];
    firewall = {
      outbound = [{
        host = "any";
        port = "any";
        proto = "any";
      }];
      inbound = [{
        host = "any";
        port = "any";
        proto = "any";
      }];
    };
    relays = [ "192.168.100.1" ];
  };

  # sops
#   sops = {
#     age.keyFile = "/var/lib/sops/sops.age.key";
#     defaultSopsFile = ./secrets/secrets.yaml;
#     defaultSopsFormat = "yaml";
#   };

  # netbird
  services.netbird.enable = true;

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



  system.stateVersion = "24.05"; # Don't touch
}
