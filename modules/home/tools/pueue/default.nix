{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  services.pueue.enable = true;
  home.packages = [ pkgs.pueue ];
}
