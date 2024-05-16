{
  pkgs,
  config,
  options,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.desktop.fonts;
in
{
  options.polytope.desktop.fonts = {
    enable = mkEnableOption "Setup default fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
        inter
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk-sans
        roboto
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "CaskaydiaCove Nerd Font" ];
          sansSerif = [
            "Inter"
            "Noto Color Emoji"
            "Noto Sans CJK JP"
          ];
          serif = [ "Noto Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
