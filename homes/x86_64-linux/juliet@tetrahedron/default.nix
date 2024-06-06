{ config, pkgs, ... }:

{
  polytope = {
    #display.sway.enable = true;
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
      nheko = {
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
      yazi = {
        enable = true;
      };
    };
  };
}
