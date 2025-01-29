{
  #config,
  #pkgs,
  ...
}:

# xray@hex

{
  polytope = {
    firefox = {
      enable = true;
      userCss = true;
    };
    neovim.enable = true;
    xdg.enable = true;
    swww.enable = true;
  };
}
