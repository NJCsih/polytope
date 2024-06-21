{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{

  # Start the service to run it
  # services.displayManager = {
  #   enable = true;
  #   execCmd = lib.mkForce "exec /run/current-system/sw/bin/lemurs";
  # };
  # Config file
  environment.etc."lemurs/config.toml".source = pkgs.writeTextFile {
    name = "lemursConfig";
    text = builtins.readFile ./config.toml;
    executable = false;
  };

  # sway entry
  environment.etc."lemurs/wayland/Sway.sh".source = pkgs.writeTextFile {
    name = "lemursSwayEntry";
    text = ''
      #! /bin/sh
      exec sway --unsupported-gpu
    '';
    executable = true;
  };
}
