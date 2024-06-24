{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
    # Enable the X11 windowing system.
    services.xserver.enable = true;

  home.file.".config/swayfx/config" = {
    text = builtins.readFile ./swayfx-config.txt;
  };

# Set swayfx config
  home.file.".config/swayfx/config" = {
    text = builtins.readFile ./swayfx-config.txt;
  };

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

}
