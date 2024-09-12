{ config, pkgs, ... }:
# xray@hex

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
      git.enable = false; # disabled so that .ssh can be done manually -- but I need it tho!
      kanata.enable = true;
      nushell.enable = true;
      sshExtraConf.enable = false;
      tealdeer.enable = true;
      yazi.enable = true;
    };
    system = {
      xdg.enable = true;
    };
  };
}
