{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.file.".config/wpaperd/config.toml" = {
    text = builtins.readFile ./config.toml;
  };
}
