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
        nerd-fonts.caskaydia-cove
        nerd-fonts.fantasque-sans-mono
        nerd-fonts.fira-code
        inter
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
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
