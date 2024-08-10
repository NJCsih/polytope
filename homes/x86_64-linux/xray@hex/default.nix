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
      git.enable = true;
      nushell.enable = true;
      yazi.enable = true;
      tealdeer.enable = true;
      kanata.enable = true;
    };
  };
}
