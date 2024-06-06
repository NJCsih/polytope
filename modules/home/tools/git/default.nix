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

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          host = "github.com";
          hostname = "github.com";
          identityFile = [ "/home/juliet/.ssh/juliet_tetrahedron" ];
          extraOptions = {
            PreferredAuthentications = "publickey";
          };
        };
      };
    };

    services.gpg-agent = {
      enable = true;
      enableNushellIntegration = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    programs.git = {
      enable = true;

      userEmail = "NJCsih@gmail.com";
      userName = "NJCsih";

      extraConfig = {
        url = {
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
        };
        init = {
          defaultBranch = "main";
        };
      };

      delta = {
        enable = true;
        options = {
          diff-so-fancy = true;
          line-numbers = true;
          true-color = "always";
        };
      };
    };
  };
}
