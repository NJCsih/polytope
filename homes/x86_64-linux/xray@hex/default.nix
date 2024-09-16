{ config, pkgs, ... }:
# xray@hex

{
  polytope = {
    apps = {
      firefox = {
        enable = true;
        userCss = true;
      };
      gimp.enable = true;
      kitty.enable = true;
      neovim.enable = true;
      nheko.enable = true;
    };
    tools = {
      git.enable = true; # disabled so that .ssh can be done manually -- but I need it tho!
      kanata.enable = true;
      nushell.enable = true;
      sshExtraConf.enable = true;
      tealdeer.enable = true;
      yazi.enable = true;
    };
    system = {
      xdg.enable = true;
    };
  };
}
