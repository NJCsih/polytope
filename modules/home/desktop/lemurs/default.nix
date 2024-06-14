{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Config file
  environment.etc."lemurs/config.toml".source = pkgs.writeTextFile {
    name = "lemursConfig";
    text = builtins.readFile ./config.toml;
    executable = false;
    destination = "/lemurs/config.toml";
  };

  # sway entry
  environment.etc."lemurs/wayland/sway".source = pkgs.writeTextFile {
    name = "lemursSwayEntry";
    #text = builtins.readFile ./config.toml;
    text = ''
      #! /bin/sh
      exec sway
    '';
    executable = true;
    destination = "/lemurs/swayEntry.sh";
  };
}
