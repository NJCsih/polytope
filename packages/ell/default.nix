{
  lib,
  stdenv,
  pkgs,
  makeWrapper,
  ...
}:
let
  requiredPackages = with pkgs; [
    nushell
  ];
in
stdenv.mkDerivation {
  pname = "l";
  version = "latest";
  src = ./ell.nu;
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
