{ config, pkgs, ... }:
# juliet@tetrahedron

{
  polytope = {
    apps = {
      firefox = {
        enable = true;
        userCss = false; # Not setup yet, need to steal from nazarick
      };
      neovim.enable = true;
      kitty.enable = true;
      nheko.enable = true;
    };
    #  displayManagers = {  # Displaymanager toggling now handled by specilizations
    #    swayfx.enable = true;
    #    plasma6.enable = false;
    #  };
    tools = {
      git.enable = true;
      nushell.enable = true;
      yazi.enable = true;
      tealdeer.enable = true;
    };
    #displayManagers = {
    #  plasma = {
    #    enable = true;
    #    noBorders = true;
    #  };
    #};
  };
}
