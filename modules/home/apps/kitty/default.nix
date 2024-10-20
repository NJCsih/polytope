{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

# *very* much stolen from nazarick. This is why you should always have your friends do the hard stuff first. :p

let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    ;

  cfg = config.polytope.apps.kitty;
in
{
  options.polytope.apps.kitty = {
    enable = mkEnableOption "Kitty";
    opacity = mkOption { type = types.str; };
    fontSize = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {

    programs.kitty = {
      #package = pkgs.kitty;
      enable = true;
      themeFile = "Catppuccin-Mocha";
      settings = {
        font_family = "CaskaydiaCove";
        italic_font = "Operator-caskabold";
        bold_italic_font = "Operator-caskabold";
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
        tab_title_max_length = 20;
        listen_on = "unix:/tmp/mykitty";
        enable_audio_bell = false;

        background = "#16161D";
        background_opacity = cfg.opacity;
        cursor_blink_interval = 0;

        term = "xterm-256color";

        font_size = cfg.fontSize;
      };
      keybindings = {
        "alt+l" = "next_tab";
        "alt+h" = "previous_tab";
        "alt+x" = "close_tab";
      };
    };
  };
}
