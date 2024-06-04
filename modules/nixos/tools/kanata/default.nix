{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.polytope.tools.kanata;
in
{
  options.polytope.tools.kanata = {
    enable = mkEnableOption "Enable kanta configuration.";
  };
  config = mkIf cfg.enable {
    services.kanata = {
      enable = true;
      package = pkgs.kanata-with-cmd;
      keyboards = {
        tetrahedron-native = {
          config = builtins.readFile ./tetrahedron-native.kbd;
          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd" # This is the inbuilt one
          ];
          extraDefCfg = ''
            process-unmapped-keys yes
            danger-enable-cmd yes
            log-layer-changes no
          '';
        };
        tetrahedron-logitec = {
          config = builtins.readFile ./tetrahedron-native.kbd;
          devices = [
            "/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-kbd" # This is an external one
          ];
          extraDefCfg = ''
            process-unmapped-keys yes
            danger-enable-cmd yes
            log-layer-changes no
          '';
        };
        #        kone = {
        #          config = builtins.readFile ./kone.kbd;
        #          devices = [
        #            "/dev/input/by-id/usb-ROCCAT_ROCCAT_Kone_XP_Air_Dongle_AB859AAB61551999-if01-event-kbd"
        #            "/dev/input/by-id/usb-ROCCAT_ROCCAT_Kone_XP_Air_Dongle_AB859AAB61551999-event-mouse"
        #          ];
        #          extraDefCfg = ''
        #            process-unmapped-keys yes
        #            danger-enable-cmd yes
        #            sequence-timeout 1000
        #            sequence-input-mode hidden-delay-type
        #            log-layer-changes no
        #          '';
        #        };
      };
    };
  };
}
