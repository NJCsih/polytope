{
  #config,
  #pkgs,
  ...
}:

# juliet@tetrahedron

{
  polytope = {
    apps = {
      firefox = {
        enable = true;
        userCss = true;
      };
      gimp.enable = true;
      kitty.enable = true;
      kitty.opacity = "0.90";
      kitty.fontSize = "11.5";
      mpv.enable = true;
      neovim.enable = true;
      nheko.enable = true;
    };
    tools = {
      cryptscript.enable = true;
      stl.enable = true;
      #easyeffects.enable = true;
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
