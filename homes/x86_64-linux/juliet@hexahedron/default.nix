{
  #config,
  #pkgs,
  ...
}:

# juliet@tetrahedron

{
  polytope = {
    firefox = {
      enable = true;
      userCss = true;
    };
    neovim.enable = true;
    qt.enable = true;
    swww.enable = true;
    xdg.enable = true;
  };
}
