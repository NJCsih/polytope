{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.file.".config/rofi/config.rasi" = {
    text = builtins.readFile ./config.rasi;
  };
  home.file.".config/rofi/catppuccin.rasi" = {
    text = builtins.readFile ./catppuccin.rasi;
  };
}
