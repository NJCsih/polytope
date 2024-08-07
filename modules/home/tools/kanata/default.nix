# This can't be hardened like the system one, so maybe make a puppet to send cmds over to?
# Make sure that your user has input/uinput groups and that system hardware.uinput is enabled
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.polytope.tools.kanata;

  workspaceHelper =
    let
      requiredPackages = with pkgs; [
        swayfx
        nushell
      ];
    in
    pkgs.stdenv.mkDerivation {
      pname = "workspace_helper";
      version = "latest";
      src = ./workspace_helper.nu;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      phases = [ "installPhase" ];
      buildInputs = requiredPackages;
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/workspace_helper
        chmod +x $out/bin/workspace_helper
        wrapProgram $out/bin/workspace_helper --prefix PATH : ${lib.makeBinPath requiredPackages}
      '';
    };

  packages = [
    pkgs.swayfx
    workspaceHelper
  ];

  mkKanataService =
    { name, file }:
    {
      Install = {
        WantedBy = [ "graphical-session.target" ]; # Make sure sway stuff is loaded into the session
      };

      Unit = {
        Description = "Kanata remapper for ${name}";
        Documentation = "https://github.com/jtroo/kanata";
      };

      Service = {
        Environment = [ "PATH=${lib.makeBinPath packages}" ];
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} --cfg ${file}";
      };
    };

in
{
  options.polytope.tools.kanata = {
    enable = lib.mkEnableOption "kanata";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.polytope.kanata;
      description = "The package for kanata";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs.polytope; [
      kanata
      workspaceHelper
    ];

    systemd.user.services = {
      "kanata-builtin" = mkKanataService {
        name = "builtin";
        file = ./builtin.kbd;
      };
      "kanata-logitec" = mkKanataService {
        name = "logitec";
        file = ./logitec.kbd;
      };
    };
  };
}
