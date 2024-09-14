{
  lib,
  config,
  #pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.tools.cryptscript;
in
{
  options.polytope.tools.cryptscript = {
    enable = mkEnableOption "Crypt Scripts";
  };

  config = mkIf cfg.enable {

    home.packages = [
      inputs.nazarick.packages.x86_64-linux.script-crypt
    ];

    systemd.user.tmpfiles.rules = [
      "L /home/${config.home.username}/.local/share/nushell - - - - /home/${config.home.username}/.local/state/home-manager/gcroots/current-home/home-path/share/nushell"
    ];

  };
}
