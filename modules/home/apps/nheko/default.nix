{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) types mkEnableOption mkIf;
  cfg = config.polytope.apps.nheko;
in
{
  options.polytope.apps.nheko = {
    enable = mkEnableOption "nheko";
  };

  config = mkIf cfg.enable { home.packages = [ (pkgs.qt6.callPackage ./nheko-unwrapped.nix { }) ]; };
}
