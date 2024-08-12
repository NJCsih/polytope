{
  config,
  lib,
  pkgs,
  ...
}:

let
in
{

  #config = lib.mkIf cfg.enable {
  config = {
    # Samba is configured, but just for the "net" command, to
    # join the domain. A better join method probably exists.
    # `net ads join -U Administrator`
    environment.systemPackages = [ pkgs.samba4Full ];
    systemd.services.samba-smbd.enable = lib.mkDefault false;
    services.samba = {
      enable = true;
      enableNmbd = lib.mkDefault false;
      enableWinbindd = lib.mkDefault false;
      package = pkgs.samba4Full;
      securityType = "ads";
      extraConfig = ''
        realm = "USERS"
        workgroup = "linux_admins"
        client use spnego = yes
        restrict anonymous = 2
        server signing = disabled
        client signing = disabled
        kerberos method = secrets and keytab
      '';
    };
  };
}
