{
  lib,
  config,
  #pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.tools.stl;
in
{
  options.polytope.tools.stl = {
    enable = mkEnableOption "stl systemctl wrapper";
  };

  config = mkIf cfg.enable {

    home.packages = [
      inputs.nazarick.packages.x86_64-linux.script-stl
    ];

    systemd.user.tmpfiles.rules = [
      "L /home/${config.home.username}/.local/share/nushell - - - - /home/${config.home.username}/.local/state/home-manager/gcroots/current-home/home-path/share/nushell"
    ];

  };
}
