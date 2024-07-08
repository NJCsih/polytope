# Forked from https://github.com/DarkKronicle/nazarick/tree/0ab68269d40c819c0b20bd1da132a13c0f4b907c/packages/wallpapers to handle private git repos
# This will cause major issues for anyone that tries to use my config though
# Eh

# Adapted from https://github.com/name-snrl/nixos-configuration/blob/d67814a85f3d93e5a2f45e6c245f11c692af2a9e/overlays/wallhaven-collection.json

{
  lib,
  pkgs,
  stdenv,
  inputs,
  system,
  wallpapers ? ./wallpapers.yml,
  name ? "system-wallpapers",
  ...
}:
let
  # previously in DarkKronicle's mylib
  importYAML =
    pkgs: file:
    builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommandNoCC "converted-yaml.json" { } ''${pkgs.yj}/bin/yj < "${file}" > "$out"''
      )
    );

  wallpapers-parsed = ((importYAML pkgs) wallpapers);
  wallpaperWrapper = import ./wallpaper.nix;
  packageWallpaper =
    wallpaper: (pkgs.callPackage (wallpaperWrapper wallpaper) { inherit inputs system; });
  finalWallpapers = lib.forEach wallpapers-parsed (w: packageWallpaper w);

in
stdenv.mkDerivation {
  pname = "system-wallpapers";
  version = "0.0.2";

  phases = [ "installPhase" ];

  dontUnpack = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wallpapers/system-wallpapers
    ${lib.concatStringsSep "\n" (
      lib.forEach finalWallpapers (wpPkg: ''
        ln -s ${wpPkg}/share/wallpapers/* $out/share/wallpapers/${name}
      '')
    )}

    runHook postInstall
  '';
}
