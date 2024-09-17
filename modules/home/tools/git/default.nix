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
          identityFile = [ "~/.ssh/github_auth_key" ];
          extraOptions = {
            PreferredAuthentications = "publickey";
          };
        };
        "github-sch" = {
          host = "github-sch";
          hostname = "github.com";
          identityFile = [ "~/.ssh/github_auth_key-sch" ];
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

      userEmail = "NJCish@gmail.com";
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
