{
  description = "A basic flake with a shell";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        tex = (pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-full
            biber; # needed for vimtex
        });

      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            tex
            pkgs.texlivePackages.latexmk
          ];
        };
      }
    );
}
