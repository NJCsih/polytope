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
      kitty = {
        enable = true;
      };
    };
    tools = {
      git = {
        enable = true;
      };
      nushell = {
        enable = true;
      };
    };
  };
}
