{ config, pkgs, ... }:
# juliet@tetrahedron

{
  polytope = {
    #display.sway.enable = true;
    apps = {
      firefox = {
        enable = true;
        userCss = false; # Not setup yet, need to steal from nazarick
      };
      neovim.enable = true;
      kitty.enable = true;
      nheko.enable = true;
    };
    displayManagers = {
      swayfx.enable = true;
      plasma6.enable = false;
    };
    tools = {
      git.enable = true;
      nushell.enable = true;
      yazi.enable = true;
      tealdeer.enable = true;
    };
  };
}
