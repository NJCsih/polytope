{ ... }:
final: prev: {
  nomachine-client = prev.nomachine-client.overrideAttrs (_: {
    src = builtins.fetchurl {
      url = "https://web9001.nomachine.com/download/9.2/Linux/nomachine_9.2.18_3_x86_64.tar.gz";
        sha256 = "sha256-/ElNG6zIOdE3Qwf/si9fKXMLxM81ZmRZmvbc6rw/M0c=";
      };
  });
}
