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

  #nix.package = inputs.lix-module.packages.x86_64-linux.default;

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
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # Wallpapers, probably move elseware at some point
  environment.pathsToLink = [ "/share/wallpapers" ];

  #   services.greetd = {
  #     enable = true;
  #     settings = {
  #       default_session = {
  #         #command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
  #         #command = "${pkgs.swayfx}/bin/sway --unsupported-gpu --config /home/juliet/.config/sway/config";
  #         command = "${pkgs.swayfx}/bin/sway --unsupported-gpu";
  #       };
  #     };
  #   };
  #  programs.sway = {
  #    enable = true;
  #    wrapperFeatures.gtk = true;
  #  };
  # cfg = config.polytope.display.sway;
  # options.polytope.display.sway = {
  #  polytope.display.sway = {
  #    enable = true;
  #  };

  # systemd.user.services.nm-applet = {
  #   description = "Network manager applet";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   after = [ "keepasspls.service" ];
  #   requiredBy = [ "keepasspls.service" ];
  #   serviceConfig = {
  #     Environment = [ "DISPLAY=:0" ];
  #     ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  #     ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
  #   };
  # };

  # systemd.user.services.keepasspls = {
  #   description = "Kee pass yes";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     Environment = [ "DISPLAY=:0" ];
  #     ExecStart = "${pkgs.nushell}/bin/nu -c '${pkgs.keepassxc}/bin/keepassxc /home/juliet/Keyring-Tetrahedron.kdbx --keyfile /home/juliet/Keyring-Tetrahedron.key'";
  #     #ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  #   };
  # };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "juliet" ];
  virtualisation.virtualbox.host.enableHardening = false;

  # TODO: move this to modules/../nvim, but not sure why that doesnt work?
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # enable settings in :
  #~/polytope/modules/nixos/system/nix/default.nix
  polytope.system.nix.enable = true;

  # enable kanata systemwide
  #~/polytope/modules/home/tools/kanata/default.nix
  # cfg = config.polytope.tools.kanata;
  # options.polytope.tools.kanata.enable = mkEnableOption "Enable kanta configuration.";
  polytope.tools.kanata.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.juliet = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "seat" # something from lemurs? idk
    ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
    shell = pkgs.nushell;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    (with pkgs; [
      #steam
      acpi
      bandwhich
      bat
      blender
      borgbackup
      bottom
      compsize
      dust
      firefox
      gcc
      gimp
      git
      git-credential-oauth
      gnupg
      gparted
      htop
      inkscape
      jetbrains.idea-community
      kanata
      keepassxc
      kitty
      lemurs
      libqalculate
      lua-language-server
      mumble
      neovim
      networkmanager
      nheko
      nixfmt-rfc-style
      nushell
      nvtop
      pfetch
      picom
      pinentry
      pipes-rs
      polybar
      polytope.poly
      pueue
      qmk
      ripgrep
      rofi
      stylua
      swayfx
      syncthing
      tealdeer
      tomb
      virtualbox
      wayland
      wget
      wl-clipboard
      wpaperd
      yazi
      zls
    ])
    ++ ([
      (inputs.nazarick.packages.x86_64-linux.system-wallpapers.override {
        # Todo: make this managed on a per-user basis not per-system
        #wallpapers = ../../../modules/nixos/desktop/wallpapers/wallpapers.yml;
        wallpapers = ./wallpapers.yml;
      })
    ]);

  environment.shells = with pkgs; [ nushell ];

  system.stateVersion = "24.05"; # Don't touch
}
