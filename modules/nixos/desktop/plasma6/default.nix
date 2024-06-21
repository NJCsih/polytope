{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.polytope.displayManagers.plasma6;
in
{
  options.polytope.displayManagers.plasma6 = {
    enable = mkEnableOption "Plasma6";
  };

  config = mkIf cfg.enable {

    # Enable the X11 windowing system.
    services.xserver.enable = true;
  
    # Enable plasma6
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

  };
}
