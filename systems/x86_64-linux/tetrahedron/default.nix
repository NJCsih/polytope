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
  services.udev.extraRules = builtins.readFile ./qmk-udev-rules.txt;

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

  polytope.mypackages.enable = true;

  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages =
    (config.polytope.mypackages.base) ++
    (config.polytope.mypackages.extra) ++
    (config.polytope.mypackages.gui.base) ++
    (config.polytope.mypackages.gui.extra) ++
    (with pkgs; [

      # Specific to this system
      logisim-evolution
      qmk
      acpilight
      tio # serial client
      acpi
      antimicrox # windows joy2key replacement -- this one's pretty cool
      (proxmark3.override {
        withGui = false;
        withPython = true;
        withGeneric = true;
        withSmall = false;
      })

      # Utils
      polytope.kanata # Latest version
      polytope.lock
      polytope.poly

    ])
    ++ [
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
        # Todo: make this managed on a per-user basis not per-system
        #wallpapers = ../../../modules/nixos/desktop/wallpapers/wallpapers.yml;
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

  networking.firewall.allowedTCPPorts = [ 56412 ];
  networking.firewall.allowedUDPPorts = [ 4242 ]; 

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
