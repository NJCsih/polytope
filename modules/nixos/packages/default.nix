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
      nushell     # Structured data woo
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
      age # better encryption tool than gpg fight me
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
      skim # fast search, like fzf, but I have fzf for the easy file search without `find | sk`
      sshfs # mount fs over ssh (very cool)
      tealdeer # Shows usage examples, this is the caching rust one
      syncthing # Probably should be a gui app, but can be used remotely on a headless box
      unzip # decompress zips
      wget
      wl-clipboard # for cli access to clipboard
      yazi # tui file explorer
      zellij # terminal multiplexer

      # Sysinfo tools
      bandwhich # show network i/o
      rustscan # Fast port scanner
      bottom # btm, slightly worse btop, but a bit cleaner
      btop # best pretty looking full-system usage info
      compsize # for showing size on disk of a file
      dust # really nice for getting size of directory, or seeing what's using space
      htop # the classic sysinfo tool
      iotop # shows drive i/o stats (req sudo)
      usbutils # don't remember what I needed this for, but real nice

      # Tools
      chezmoi # for dotfile management (I mostly left home manager)
      imagemagick # good for easy img manipulation (like downnsizing/compression)
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

      # Compilation stuff
      gnumake
      gcc
      clang
      pkgs.man-pages
      pkgs.man-pages-posix

      # Cool tools
      phraze # cool wordlist generator
      pipes-rs # 2d little pipes thing

    ]);
    polytope.mypackages.gui.base = (with pkgs; [

      # main apps
      brave # firefox installed by home manager
      keepassxc # password database
      mullvad-vpn # my vpn

      # Other apps
      gimp # the classic
      kdePackages.okular # I know this is gonna pull so many kde dependencies but eh
      nheko # matrix client
      pdfarranger # for rearranging, concatenating, and separating pdfs
      wireshark # network analysis / packet capture

      # Interaction
      wayland # probably don't need to manually install wayland but eh
      swayfx # window manager
      waybar # bae
      kitty # Terminal emulator, this one's rad, see chezmoi for dots
      swaylock # screen locker
      wdisplays # for managing and rearranging displays
      swww # Wallpaper display
      rofi # app launcher
      networkmanagerapplet # for configuring wifi
      grim # screenshotting 1/2
      slurp # screenshotting 2/2

      # Audio
      mumble # foss voice chat
      easyeffects # noise canceling + audio tools
      lxqt.pavucontrol-qt # volume control
      qpwgraph # pipewire nodes graph viewer

    ]);
    polytope.mypackages.gui.extra = (with pkgs; [

      # Audio
      audacity # the classic foss audio recording/editing
      glava # visualizer, may change to a diff one at some point

      # Extra apps
      blender # whole bunch of rendering/video/editing tools in a great foss app
      inkscape # foss vector editing tool
      kdePackages.dolphin # file viewer, as nice as it is with themeing, I just use yazi mostly
      kdePackages.gwenview # image viewer
      krita # drawing all, nice for pdf markup along with pdfarranger
      mpv # video player -- config should be via home manager #TODO
      obsidian # For notes, but I don't use it much
      prusa-slicer # 3d printer slicer, I never use this on these machines
      snes9x # snes emulator
      antimicrox # windows joy2key replacement for games/remaps of controllers
      stellarium # planet/night sky program
      virtualbox # virtual machines

    ]);

  };
}
