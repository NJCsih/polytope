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
    xdg.enable = true;
  };
}
