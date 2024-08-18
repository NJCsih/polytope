{
  lib,
  stdenv,
  pkgs,
  makeWrapper,
  ...
}:
let
  requiredPackages = with pkgs; [ nushell swaylock ];
in
stdenv.mkDerivation {
  pname = "lock";
  version = "latest";
  #wallpaperPath = "/run/current-system/sw/share/wallpapers/system-wallpapers";
  src = ./lock.nu;
  nativeBuildInputs = [ makeWrapper ];
  phases = [ "installPhase" ];
  buildInputs = requiredPackages;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/lock
    chmod +x $out/bin/lock
    wrapProgram $out/bin/lock --prefix PATH : ${lib.makeBinPath requiredPackages}
  '';
}
