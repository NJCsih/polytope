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
      cryptscript.enable = true;
      #easyeffects.enable = true;
      git.enable = true;
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
