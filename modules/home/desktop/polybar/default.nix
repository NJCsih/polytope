{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.file.".config/polybar/config.ini" = {
    text = builtins.readFile ./config.ini;
  };
}
