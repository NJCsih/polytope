{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.polytope.qt;
in
{

  options.polytope.qt = {
    enable = lib.mkEnableOption "qt";
  };
  config = lib.mkIf cfg.enable {

    # INFO: This will probably *not* set your system level environment variables, so make sure to do system stuff.
    qt = {
      enable = true;
      style.package = [
        inputs.darkly.packages.${pkgs.system}.darkly-qt5
        inputs.darkly.packages.${pkgs.system}.darkly-qt6
      ];
      style.name = "Darkly";
      platformTheme.name = "qtct";
    };

    gtk = {
      iconTheme = {
        name = "Fluent-dark";
        package = pkgs.fluent-icon-theme;
      };
      cursorTheme = {
        package = pkgs.catppuccin-cursors.mochaMauve;
        name = "Catppuccin-Mocha-Mauve-Cursors";
      };
      theme.package = pkgs.kdePackages.breeze-gtk;
      enable = true;
      theme.name = "Breeze";
      gtk2.configLocation = "${config.home.homeDirectory}/.config/gtk-trash/gtkrc";
    };

    home.sessionVariables.GTK2_RC_FILES = lib.mkForce "${config.home.homeDirectory}/.gtkrc-2.0";

    home.packages = with pkgs; [
      inputs.darkly.packages.${pkgs.system}.darkly-qt6
      fluent-icon-theme
      kdePackages.qt6ct
      kdePackages.ark
      kdePackages.okular
      kdePackages.phonon-vlc
      kdePackages.ffmpegthumbs
      kdePackages.kimageformats
      kdePackages.print-manager
      catppuccin-cursors.mochaMauve
    ];

    programs.wlogout = {
      enable = true;
      layout = [
        {
          "label" = "lock";
          "action" = "swaylock && ${pkgs.keepassxc}/bin/keepassxc --lock";
          "text" = "Lock";
        }
        {
          "label" = "logout";
          "action" = "swaymsg exit";
          "text" = "Logout";
        }
        {
          "label" = "shutdown";
          "action" = "systemctl poweroff";
          "text" = "Shutdown";
          "keybind" = "s";
        }
        {
          "label" = "suspend";
          "action" = "systemctl suspend";
          "text" = "Suspend";
          "keybind" = "u";
        }
        {
          "label" = "reboot";
          "action" = "systemctl reboot";
          "text" = "Reboot";
          "keybind" = "r";
        }
      ];
    };

    # Make it so icons are nice and small
    xdg.configFile."dolphinrc" = {
      enable = true;
      text = ''
        [DetailsMode]
        PreviewSize=16

        [KFileDialog Settings]
        Places Icons Auto-resize=false
        Places Icons Static Size=22

        [MainWindow]
        MenuBar=Disabled
        ToolBarsMovable=Disabled
      '';
    };

    xdg.configFile."darklyrc" = {
      enable = true;
      text = ''
        [Style]
        DolphinSidebarOpacity=80
        MenuBarOpacity=80
        MenuOpacity=80
        TabDrawHighlight=true
        ToolBarOpacity=80
      '';

    };

    # This has to be inside this directory for some reason (can't link from wherever)
    # TODO: Actually maybe not

    # Quick and dirty way to get colors to apply for everything (including you, kdeconnect)
    # MVP this random forum post https://forum.endeavouros.com/t/getting-kdeconnect-to-use-kvantum-theme-outside-of-plasma/57717

    # Fix color scheme :D
    # https://github.com/NixOS/nixpkgs/issues/355602#issuecomment-2495539792

    xdg.configFile."kdeglobals" = {
      enable = true;
      text =
        ''
          [UiSettings]
          ColorScheme=*
        ''
        + (builtins.readFile "${
          pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
            accents = [ "mauve" ];
          }
        }/share/color-schemes/CatppuccinMochaMauve.colors");
    };

    xdg.configFile."qt5ct/colors/gruvbox.conf" = {
      enable = true;
      source = ./gruvbox.conf;
    };

    xdg.configFile."qt6ct/colors/gruvbox.conf" = {
      enable = true;
      source = ./gruvbox.conf;
    };

    xdg.configFile."qt5ct/qt5ct.conf" = {
      enable = true;
      source = pkgs.substitute {
        src = ./qt5ct.conf;
        substitutions = [
          "--replace-fail"
          "##COLORSCHEME##"
          "/home/${config.home.username}/.config/qt6ct/colors/gruvbox.conf"
        ];
      };
    };

    xdg.configFile."qt6ct/qt6ct.conf" = {
      enable = true;
      source = pkgs.substitute {
        src = ./qt6ct.conf;
        substitutions = [
          "--replace-fail"
          "##COLORSCHEME##"
          "/home/${config.home.username}/.config/qt6ct/colors/gruvbox.conf"
        ];
      };
    };
  };

}
