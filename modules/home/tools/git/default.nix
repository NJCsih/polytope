{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.tools.git;
in
{
  options.polytope.tools.git = {
    enable = mkEnableOption "Git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      userEmail = "NJCsih@gmail.com";
      userName = "NJCsih";
    };
    #programs.git-credential-oauth-enable = true;
    #programs.gitui.enable = true;
  };
}
