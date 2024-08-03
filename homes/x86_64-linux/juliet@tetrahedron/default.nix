{ config, pkgs, ... }:
# juliet@tetrahedron

{
  polytope = {
    apps = {
      firefox = {
        enable = true;
        userCss = false; # Not setup yet, need to steal from nazarick
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

    #displayManagers = {
    #  plasma = {
    #    enable = true;
    #    noBorders = true;
    #  };
    #};
  };
}
