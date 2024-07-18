{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Set rofi config
  home.file.".config/rofi/config.rasi" = {
    text = builtins.readFile ./rofi-config.rasi;
  };
  home.file.".config/rofi/catppuccin.rasi" = {
    text = builtins.readFile ./rofi-catppuccin.rasi;
  };

  # Set wpaperd config
  home.file.".config/wpaperd/config.toml" = {
    text = builtins.readFile ./wpaperd-config.toml;
  };

  # Swayfx config
  wayland.windowManager.sway = {
    enable = true;
    package = null; # Let NixOS handle this one
    checkConfig = false; # Annoying with swayfx
    # good luck lol
    extraConfig = builtins.readFile (./swayfx-config.txt);
    # This is some neat code stolen from nazarick, which can be used to replace arbitrary text, which would be nice for consistent colorschemes
    # pkgs.substitute {
    # src = ./swayfx-config.txt;
    # substitutions = [
    # "--replace-fail"
    # "##LAUNCHER##"
    # launcher
    # "--replace-fail"
    # "##LOCKCMD##"
    # "swaylock -f -c 000000"
    # ];
    # }
    # ); # closes extraConfig
    systemd.enable = true; # This is the important bit
    #config = { # I'm just gonna do it all from the config file
    #  menu = launcher;
    #  terminal = "kitty";
    #  keybindings = { }; # Remove default
    #  bars = [ ]; # Remove default
    #};
  };
}
