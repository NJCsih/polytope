{
  pkgs,
  config,
  options,
  inputs,
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
      nushell
      atuin       # History
      pfetch-rs   # :3
      starship    # Prompt
      zoxide      # cd jumps

      # Nix
      nh # nicer script for rebuilding
      nom # cool build tree visualizer
      nix-direnv # for auto nix develop on cd (very nice)
      nix-tree # shows tree graph of nix flake
      nixfmt-rfc-style # nixos autoformatter

      # Cli tools
      age # better encryption tool than gpg
      bat # better cat
      borgbackup # backup tool, dedup+remote+encrpytion
      broot # fast recursive cd
      fd # fast cd search
      file # stat and such
      fzf # fast cd search
      git
      gitoxide # git rewrite, faster for large clones
      inxi # pulls system info
      libqalculate # best tui calculator
      libsecret # cli secret access -- needed for script to check keepass state
      lsof # cool tool, shows open files and sockets
      magic-wormhole-rs # large file transfer
      ov # pager (nice for man pages)
      ripgrep # faster grep
      skim # fast search
      sshfs # mount fs over ssh (very cool)
      tealdeer # Shows usage examples
      unzip # decompress zips
      wget
      wl-clipboard # for cli access to clipboard
      yazi # tui file explorer

      # Sysinfo tools
      bandwhich # show network i/o
      rustscan # Fast port scanner
      bottom # btm, slightly worse btop
      btop # best pretty looking full-system usage info
      compsize # for showing size on disk of a file
      dust # really nice for getting size of directory
      htop # the classic sysinfo tool
      iotop # shows drive i/o stats (req sudo)
      usbutils # provides utils

      # Tools
      chezmoi # for dotfile management (I mostly left home manager)
      imagemagick # good for easy img manipulation (like downnsizing)
      nix-direnv # for auto nix develop on cd (very nice)
      nix-tree # shows tree graph of nix flake
      nixfmt-rfc-style # nixos autoformatter
      qrencode # generates qrcodes

      # Networking
      nebula # for direct connection of multiple devices behind nats
      networkmanager # for wifi connection

      # tomb:
      tomb # For on-disk luks
      gnupg # tomb dep
      pinentry # tomb dep

    ]);
    polytope.mypackages.extra = (with pkgs; [
      mullvad-vpn
      pipes-rs

      # Compilation stuff
      gnumake
      gcc
      clang
      pkgs.man-pages
      pkgs.man-pages-posix

    ]);
    polytope.mypackages.gui.base = (with pkgs; [
      mumble
      kdePackages.okular # I know this is gonna pull so many kde dependencies but eh
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

      swayfx
      waybar
      wayland
      swaylock

      # For screenshotting
      grim
      slurp
    ]);
    polytope.mypackages.gui.extra = (with pkgs; [
      audacity
      blender
      brave
      easyeffects
      glava # visualizer, may change to a diff one at some point
      kdePackages.gwenview
      inkscape
      kdePackages.dolphin
      krita
      mpv
      obsidian
      prusa-slicer
      #snes9x # TODO: -- failed?
      stellarium
    ]);

  };
}
