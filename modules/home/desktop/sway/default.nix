{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.file.".config/swayfx/config" = {
    text = builtins.readFile ./config;
  };
}
