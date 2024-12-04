# Like all good things, yoinked from nazarick :p
# . _. I do not have time for this distro...

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.security.sudo;
in
{
  options.polytope.security.sudo = {
    enable = mkEnableOption "Enable sudo configuration";
    removeFirstMessage = mkEnableOption "Remove first message about sudo";
  };
  config = mkIf cfg.enable {
    security.sudo = {
      # Defaults  lecture_file="/path/to/file" - could be fun
      extraConfig = ''
        Defaults  lecture="never"
        Defaults env_keep += "EDITOR PATH DISPLAY"
      '';
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            {
              command = "${pkgs.tomb}/bin/tomb close";
              options = [
                "NOPASSWD"
                "SETENV"
              ];
            }
            {
              command = "${pkgs.tomb}/bin/tomb slam";
              options = [
                "NOPASSWD"
                "SETENV"
              ];
            }
            {
              command = "${pkgs.tomb}/bin/tomb list";
              options = [
                "NOPASSWD"
                "SETENV"
              ];
            }
          ];
        }
      ];
    };
  };
}

