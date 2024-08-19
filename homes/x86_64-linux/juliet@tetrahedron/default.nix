{ config, pkgs, ... }:
# juliet@tetrahedron

{
  polytope = {
    apps = {
      firefox = {
        enable = true;
        userCss = true;
      };
      kitty.enable = true;
      neovim.enable = true;
      nheko.enable = true;
    };
    tools = {
      git.enable = true;
      nushell.enable = true;
      yazi.enable = true;
      tealdeer.enable = true;
      kanata.enable = true;
      #easyeffects.enable = true;
    };
    system = {
      xdg.enable = true;
    };

    de = {
      #swww.enable = true; # I dont actually need it to be enabled/disabled, just always run, and what wps it does are not it's problem
    };
  };
}
