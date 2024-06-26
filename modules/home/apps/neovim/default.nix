{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) types mkEnableOption mkIf;
  cfg = config.polytope.apps.neovim;
in
{
  options.polytope.apps.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = false;
      withRuby = false;
      withPython3 = false;
    };
  };
}
