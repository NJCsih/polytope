{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

# *very* much stolen from nazarick. This is why you should always have your friends do the hard stuff first. :p

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.polytope.apps.kitty;
in
{
  options.polytope.apps.kitty = {
    enable = mkEnableOption "Kitty";
  };

  config = mkIf cfg.enable {

    programs.kitty = {
      #package = pkgs.kitty;
      enable = true;
      theme = "Catppuccin-Mocha";
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

        background_opacity = "0.90";
        cursor_blink_interval = 0;

        # font_size = "11.3";

        background = "#16161D";
      };
      keybindings = {
        "alt+l" = "next_tab";
        "alt+h" = "previous_tab";
        "alt+x" = "close_tab";
      };
    };
  };
}
