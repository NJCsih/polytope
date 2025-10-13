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
  polytope.network.dnscrypt.enable = false;

  # Enable sound.
  services.pulseaudio.enable = false;

  # System Stuff ----------------------------------------------------------------------------------

  networking.hostName = "hex"; # Define your hostname.

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # [Re efi canTouchEfiVariables] "I have it enabled tho I don't remember quite
  # exactly what it does" - DarkKronicle -- I'm trusting them

  boot.loader.timeout = 0;

  # Zen is for desktop computing, so lower latency? I'm not gonna touch it
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
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
  # No udev rules for this host

  # Medium system level Stuff ------------------------------------------------------------------------------------

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # Wallpapers TODO: Redo the whole wallpaper thing, they should probably be defined per-user
  environment.pathsToLink = [ "/share/wallpapers" ];

  # udisk 2 nice for things, allows unprivileged users to mount
  services.udisks2.enable = true;

  # User Stuff ------------------------------------------------------------------------------------

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
    ];
    initialPassword = "password";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRrhxeyOqZvgrpJUhqy6QryNZ0Eq24INsdedeBBgSPs" # juliet@tetrahedron
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIj1yGIgjwj+o6mfn43JC3m8puUzQhMi1sTI5Y99Fn4" # juliet@hexahedron
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvH5PDc2pZkNK6hsQg81mICTspHIe2LrxJrxLHYmiQ8" # voxel
    ];
  };
  environment.shells = [ pkgs.nushell ];

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
    #(config.polytope.mypackages.gui.extra) ++
    (with pkgs; [

      # Specific to this system
      tio # serial client
      freerdp3 # RD client
      krb5 # For kerberos auth

      # Yes in gui.extra but I want it without that
      chromium

    ])
    ++ [
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
        wallpapers = ./wallpapers.yml;
      })
    ];

  # Flatpak for rdp
  services.flatpak.enable = true;

# Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 37485 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "xray" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };
  services.fail2ban.enable = true;

  programs.wireshark.enable = true; # set extra stuff for wireshark

  # 37485 is for ssh
  # 22000 is for syncthing
  networking.firewall.allowedTCPPorts = [ 37485 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 ];

  # enable xrdp stuff
  services.xrdp.enable = true; # remote desktop service
  services.xrdp.defaultWindowManager = "${lib.getExe config.programs.sway.package}";
  services.xrdp.openFirewall = true;


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

  # use default dns
  home-manager.users.juliet = {  # Some cursed shenangains to make a home manager scope,
    programs.firefox.profiles.main.arkenfox."0700".enable = lib.mkOverride 150 false;
    programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".enable = true; # Set this setting
    programs.firefox.profiles.main.arkenfox."0700"."0710"."network.trr.mode".value = lib.mkOverride 150 0; # use default resolver
  };

  system.stateVersion = "24.05"; # Don't touch
}
