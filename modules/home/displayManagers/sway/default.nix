{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.polytope.displayManagers.swayfx;
in
{
  options.polytope.displayManagers.swayfx = {
    enable = mkEnableOption "Swayfx";
  };

  config = mkIf cfg.enable {

    # Set swayfx config
    home.file.".config/swayfx/config" = {
      text = builtins.readFile ./swayfx-config.txt;
    };
  
    # Set rofi config
    home.file.".config/rofi/config.rasi" = {
      text = builtins.readFile ./rofi-config.rasi;
    };
    home.file.".config/rofi/catppuccin.rasi" = {
      text = builtins.readFile ./rofi-catppuccin.rasi;
    };
  
    # Set wpaperd config
    home.file.".config/wpaperd/config.toml" = {
      text = builtins.readFile ./wpaperd-config.toml;
    };

  };
}
