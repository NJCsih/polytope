{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  #inherit (lib) mkLocalCert;

  # TODO: Fix inherits? I gave up it's been a while
  mkCA =
    pkgs:
    pkgs.runCommand "mkcert-CA" { } ''
      mkdir -p $out/certs
      HOME=$TMPDIR
      CAROOT=$out
      ${pkgs.mkcert}/bin/mkcert tmp.local
      mv $HOME/.local/share/mkcert/* $out/
    '';

  mkLocalCert =
    pkgs: domains: name:
    pkgs.runCommand "mkcert-${domains}" { } ''
      mkdir -p $out
      HOME=$TMPDIR
      mkdir -p $HOME/.local/share/mkcert/
      cp ${mkCA pkgs}/root* $HOME/.local/share/mkcert/
      CAROOT=${mkCA pkgs}
      cd $out
      ${pkgs.mkcert}/bin/mkcert -cert-file=${name}.pem -key-file=${name}-key.pem ${domains}
    '';

  cfg = config.polytope.network.dnscrypt;

  # Hasn't updated in 2 years, so should be ok
  generate-domains-blocklist = pkgs.callPackage ./python-blocklist.nix { };

  blocklist = pkgs.callPackage (import ./generate-blocklist.nix {
    blocklist = "${inputs.blocklist}/hosts/pro.plus.txt";
    name = "pro-plus-blocklist";
    version = inputs.blocklist.shortRev;
    generate-domains-blocklist = "${generate-domains-blocklist}/generate-domains-blocklist.py";
  }) { };

  cert = mkLocalCert pkgs "localhost 127.0.0.1 ::1" "localhost";
in
{
  options.polytope.network.dnscrypt = {
    enable = mkEnableOption "Enable dnscrypt configuration.";
  };

  config = mkIf cfg.enable {

    security.pki.certificateFiles = [ "${mkCA pkgs}/rootCA.pem" ];

    networking = {
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
      networkmanager.dns = "none";
    };

    environment.systemPackages = [
      # Captive portal helper
      (lib.polytope.writeScript pkgs "default-dns" (builtins.readFile ./default-dns.nu))
    ];

    services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv4_servers = true;
        ipv6_servers = true;
        block_ipv6 = false;
        doh_servers = true;

        # I had some issues here, but it turns out dnssec requires a filter
        require_nofilter = false; # quad9 has some nice security filters
        require_dnssec = true;

        forwarding_rules = "${./forwarding-rules.txt}";

        sources.quad9-resolvers = {
          urls = [
            "https://quad9.net/dnscrypt/quad9-resolvers.md"
            "https://raw.githubusercontent.com/Quad9DNS/dnscrypt-settings/main/dnscrypt/quad9-resolvers.md"
          ];
          minisign_key = "RWTp2E4t64BrL651lEiDLNon+DqzPG4jhZ97pfdNkcq1VDdocLKvl5FW";
          cache_file = "/var/lib/dnscrypt-proxy/quad9-resolvers.md";
          prefix = "quad9-";
        };

        blocked_names = {
          blocked_names_file = "${blocklist}/share/blocklist/pro-plus-blocklist.txt";
        };

        local_doh = {
          listen_addresses = [ "127.0.0.1:3000" ];
          path = "/dns-query";
          cert_file = "${cert}/localhost.pem";
          cert_key_file = "${cert}/localhost-key.pem";
        };
      };
    };

    # https://github.com/NixOS/nixpkgs/issues/170573
    # TLDR: when using StateDirectory, systemd will strong arm control for it.
    # it creates a /var/lib/private thing, confusing, bind mounting that will
    # freak out because it's using a dynamic user. Last thing we want
    # is for DNS to not work on the system. Setting ReadWritePaths gives
    # us full control, and allows us to persist it correctly.
    systemd.services.dnscrypt-proxy2.serviceConfig = {
      StateDirectory = lib.mkForce "";
      ReadWritePaths = "/var/lib/dnscrypt-proxy";
    };

    # Make sure this directory exists so the service doesn't fail on boot
    systemd.tmpfiles.rules = [ "d /var/lib/dnscrypt-proxy 0755 root root -" ];
  };
}
