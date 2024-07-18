{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Set waybar config
  home.file.".config/waybar/config" = {
    text = builtins.readFile ./config.jsonc;
  };

  # Set styling file # TODO: color replacement
  home.file.".config/waybar/style.css" = {
    text = builtins.readFile ./style.css;
  };
}
