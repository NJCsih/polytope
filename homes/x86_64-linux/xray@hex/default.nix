{
  #config,
  #pkgs,
  ...
}:

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
      cryptscript.enable = true;
      git.enable = true;
      kanata.enable = true;
      nushell.enable = true;
      nushell.zoxide.enable = true;
      sshExtraConf.enable = false;
      tealdeer.enable = true;
      yazi.enable = true;
    };
    system = {
      xdg.enable = true;
    };
  };
}
