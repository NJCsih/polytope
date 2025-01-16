{
  pkgs,
  config,
  options,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.mypackages;
in
{
  options.polytope.mypackages = {
    enable = mkEnableOption "Install default packages on system";
    base = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Base packages to be on all machines";
    };
    extra = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra packages for machines I use interactively";
    };
    gui.base = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Base packages requiring gui";
    };
    gui.extra = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Packages requiring gui, and may not be nessecary";
    };
  };

  # But what is 'config'?
  config = mkIf cfg.enable {
    polytope.mypackages.base = (with pkgs; [


      # Shell
      atuin
      nushell
      pfetch-rs
      starship # for nushell
      zoxide

      # Cli tools
      age
      bat
      borgbackup
      broot
      fd
      file # stat and such
      fzf
      git
      gitoxide
      inxi # pulls system info
      libqalculate
      magic-wormhole-rs
      ov # pager (nice for man pages)
      ripgrep
      skim
      sshfs
      unzip
      wget
      yazi

      # Sysinfo tools
      bandwhich
      bottom
      btop
      compsize # for showing size on disk of a file
      dust
      htop
      iotop
      nvtopPackages.full
      usbutils

      # Tools
      chezmoi
      imagemagick
      nixfmt-rfc-style
      nix-direnv
      nix-tree
      qrencode

      # Networking
      nebula
      networkmanager

      # tomb:
      tomb # For on-disk luks
      gnupg # tomb dep
      pinentry # tomb dep

    ]);
    polytope.mypackages.extra = (with pkgs; [
      mullvad-vpn
      pipes-rs
      gnumake
      gcc
      tealdeer
    ]);
    polytope.mypackages.gui.base = (with pkgs; [
      mumble
      okular # I know this is gonna pull so many kde dependencies but eh
      nheko
      swww
      rofi
      virtualbox
      gimp
      kitty
      lxqt.pavucontrol-qt
      pdfarranger
      syncthing
      wireshark

      networkmanagerapplet

      keepassxc

      # For screenshotting
      grim
      slurp
    ]);
    polytope.mypackages.gui.extra = (with pkgs; [
      mpv
      obsidian
      glava # visualizer, may change to a diff one at some point
      audacity
      kdePackages.dolphin
      stellarium
      snes9x
      blender
      prusa-slicer
      inkscape
      brave
      gwenview
      krita
    ]);

  };
}
