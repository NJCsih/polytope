{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) types mkEnableOption mkIf;
  cfg = config.polytope.tools.yazi;
in
{
  options.polytope.tools.yazi = {
    enable = mkEnableOption "Yazi";
  };

  config = mkIf cfg.enable {

    programs.yazi = {
      enable = true;
      settings = {
        manager = {
          linemode = "size";
          show_hidden = true;
          scrolloff = 8;
        };
      };
    };
  };
}
