{ channels, ... }:

final: prev:

{
  nixUnstable = prev.nixVersions.git; 

  tomb =
    let
      extras-kdf = prev.stdenv.mkDerivation {
        pname = "tomb-extras-kdf-keys";
        version = prev.tomb.version;

        src = "${prev.tomb.src}/extras/kdf-keys";

        nativeBuildInputs = with prev; [
          gcc
          libgcrypt
          gnumake
        ];

        installPhase = ''
          install -Dm755 tomb-kdb-pbkdf2 $out/bin/tomb-kdb-pbkdf2
          install -Dm755 tomb-kdb-pbkdf2-getiter $out/bin/tomb-kdb-pbkdf2-getiter
          install -Dm755 tomb-kdb-pbkdf2-gensalt $out/bin/tomb-kdb-pbkdf2-gensalt
        '';
      };
    in
    prev.symlinkJoin {
      inherit (prev.tomb) name version;
      paths = [ prev.tomb ];
      buildInputs = [ prev.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/tomb --prefix PATH : ${prev.lib.makeBinPath [ extras-kdf ]}
      '';
    };
}
