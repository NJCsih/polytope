# Taken from https://github.com/DarkKronicle/nazarick/tree/main/packages/naz
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
    ripgrep
    nixfmt-rfc-style
    git
    nix-output-monitor
    nh
    nvd
  ];
in
stdenv.mkDerivation {
  pname = "poly";
  version = "latest";
  src = ./poly.nu;
  nativeBuildInputs = [ makeWrapper ];
  phases = [ "installPhase" ];
  buildInputs = requiredPackages;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/poly
    chmod +x $out/bin/poly
    wrapProgram $out/bin/poly --prefix PATH : ${lib.makeBinPath requiredPackages}
  '';
}
