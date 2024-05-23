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
    #wayland.windowManager.sway.enable = true;
    #wayland.windowManager.sway.extraConfig = builtins.readFile ./config.txt;
  };
}
