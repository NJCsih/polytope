{ config, pkgs, ... }:
# xray@hex

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
    #  displayManagers = {  # Displaymanager toggling now handled by specilizations
    #    swayfx.enable = false;
    #    plasma6.enable = true;
    #  };
    tools = {
      git.enable = true;
      nushell.enable = true;
      yazi.enable = true;
      tealdeer.enable = true;
    };
  };
}
