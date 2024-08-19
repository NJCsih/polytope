{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.tools.sshExtraConf;
in
{
  options.polytope.tools.sshExtraConf = {
    enable = mkEnableOption "sshExtraConfig";
  };

  config = mkIf cfg.enable {

    programs.ssh = {
      enable = true;
      extraConfig = builtins.readFile (./sshExtraConfig.txt);
    };
  };
}
