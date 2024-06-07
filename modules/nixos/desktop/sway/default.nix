{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.display.sway;
in
{
  options.polytope.display.sway = {
    enable = mkEnableOption "Enable sway configuration.";
  };
  config = mkIf cfg.enable {
    #wayland.windowManager.sway = {
    #wayland.windowManager.sway = {
    #  enable = true;
    #  extraConfig = builtins.readFile ./config.txt;
    #  extraOptions = [ "--unsupported-gpu" ];
    #};
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "kitty";
        startup = [
          # Launch Firefox on start
          { command = "firefox"; }
        ];
      };
    };
  };
}
