{ config, pkgs, ... }:

{
  polytope = {
    apps = {
      firefox = {
        enable = true;
        userCss = false; # Not setup yet, need to steal from nazarick
      };

      neovim = {
        enable = true;
      };
    };
    tools = {
      git = {
        enable = true;
      };
    };
  };
}
