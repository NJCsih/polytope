{ stdenv, dnscrypt-proxy, ... }:
stdenv.mkDerivation {
  pname = "generate-domains-blocklist";
  version = "0059194a-patch";

  dontUnpack = true;
  src = dnscrypt-proxy.src;

  buildPhase = ''
    mkdir -p $out/
    patch $src/utils/generate-domains-blocklist/generate-domains-blocklist.py -o $out/generate-domains-blocklist.py < ${./no-trusted.patch}
  '';
}
