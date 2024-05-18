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

  polytope = {
    desktop = {
      fonts = enabled;
    };
  };

  # Use the GRUB 2 boot loader.
  boot.loader.systemd-boot.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  nix.package = inputs.lix-module.packages.x86_64-linux.default;

  networking.hostName = "tetrahedron"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable NUR
  #nixpkgs.config.packageOverrides = pkgs: {
  #nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #inherit pkgs;
  #};
  #};

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Set nvim to be default, TODO: Move this to nvim's modules/../nvim/default.nix
  #programs.neovim = {
  #  enable = true;
  #  defaultEditor = true;
  #};
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  #polytope.apps.neovim = {
  #  enable = true;
  #  defaultEditor = true;
  #};

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

  # Enable the Plasma 5 Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
    shell = pkgs.nushell;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bandwhich
    borgbackup
    compsize
    dust
    firefox
    gimp
    git
    git-credential-oauth
    gparted
    htop
    jetbrains.idea-community
    kitty
    libqalculate
    mumble
    neovim
    nixfmt-rfc-style
    nushell
    pfetch
    pipes-rs
    polytope.poly
    ripgrep
    tealdeer
    wget
    wl-clipboard
    yazi
  ];

  environment.shells = with pkgs; [ nushell ];

  system.stateVersion = "24.05"; # Don't touch
}
