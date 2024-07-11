{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.polytope.system.nix;
in
{
  security.polkit.extraConfig = ''

  '';

  security.wrappers = {
    gparted = {
      owner = "root";
      group = "root";
      setuid = true;
      source = "${pkgs.gparted}/bin/gparted";
    };
  };
}
