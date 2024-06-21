{ config, pkgs, ... }:
# xray@hex

{
  polytope = {
    #display.sway.enable = true;
    apps = {
      firefox = {
        enable = true;
        userCss = false; # Not setup yet, need to steal from nazarick
      };
      kitty.enable = true;
      neovim.enable = true;
      nheko.enable = true;
    };
    displayManagers = {
      swayfx.enable = false;
      plasma6.enable = true;
    };
    tools = {
      git.enable = true;
      nushell.enable = true;
      yazi.enable = true;
      tealdeer.enable = true;
    };
  };
}
