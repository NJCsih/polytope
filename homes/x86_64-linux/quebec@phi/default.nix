{
  #config,
  #pkgs,
  ...
}:

# quebec@phi

{
  polytope = {
    apps = {
      firefox = {
        enable = false;
        userCss = false;
      };
      gimp.enable = false;
      kitty.enable = true;
      kitty.opacity = "1";
      kitty.fontSize = "13.0";
      mpv.enable = false;
      neovim.enable = true;
      nheko.enable = false;
    };
    tools = {
      cryptscript.enable = true;
      stl.enable = true;
      git.enable = true;
      kanata.enable = false;
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
