{
  lib,
  config,
  #pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.apps.neovim;
in
{
  options.polytope.apps.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {

    home.packages = [ inputs.nvim-cats.packages.x86_64-linux.default ];
    home.sessionVariables.EDITOR = "nvim";
  };
}
