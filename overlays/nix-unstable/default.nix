{ channels, ... }:

final: prev:

{
  nixUnstable = prev.nixVersions.git; 

  # tomb forge --kdf 32 --kdftype argon2 --kdfmem 22 -f my_tomb.tomb.key
  # kdf is rounds, standard argon stuff
  # kdfmem is given by 2^n kB
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
