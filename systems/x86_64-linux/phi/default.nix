{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];
  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Zen is for desktop computing, so lower latency? I'm not gonna touch it
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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

  # Enable sound.

  # User Stuff ------------------------------------------------------------------------------------

  networking.hostName = "phi"; # Define your hostname.

  # Define my user
  users.users.quebec = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1nAUrHB4fRm0J9EKHHC7qX3Q4lwuao9QUPD2/lPEKj" # xray@hex
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH0aC1qvRV1JTNU6JNOGL4E0Bb/WaPuddsStuq1Z2oZL" # juliet@tetrahedron
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAweQUAfQeJbYaR8LOoaNBbsTJPpOGnbsF4SxO7nSbst" # voxel
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Systemwide Packages ---------------------------------------------------------------------------
  environment.systemPackages =
    (with pkgs; [

      # Apps
      pfetch-rs

      # Programs
      nushell
      starship # for nushell

      # Cryptography
      # DarkKronicle's crypt-scripts are handled by a hm module
      age
      magic-wormhole-rs

      # Tools
      borgbackup
      gimp
      git
      gitoxide
      gparted
      grim
      keepassxc
      kitty
      lxqt.pavucontrol-qt
      neovim
      networkmanager
      nix-tree
      onionshare
      slurp
      syncthing
      tio # serial client
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
      libqalculate
      networkmanagerapplet
      nixfmt-rfc-style
      pciutils
      #pipes-rs
      #polytope.kanata # Latest version
      #polytope.lock
      #polytope.poly
      ripgrep
      swww
      tcpdump
      tealdeer
      tomb
      gnupg # tomb dep
      pinentry-gnome3 # tomb dep
      unzip
      wget
      wl-clipboard

      # myPackages

    ]);

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 37485 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "quebec" ];
      UseDns = true;
      X11Forwarding = false;
      #PermitRootLogin = "no";
    };
  };
  services.fail2ban.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 37485 ];
  # networking.firewall.allowedUDPPorts = [ ... ];


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.05"; # Don't touch
}
