{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.file.".local/share/dbus-1/services/org.freedesktop.secrets.service" = {
    text = ''
      [D-BUS Service]
      Name=org.freedesktop.secrets
        Exec=${pkgs.nushell}/bin/nu -c "DESKTOP=:0 ${pkgs.keepassxc}/bin/keepassxc /home/juliet/Keyring-Tetrahedron.kdbx --keyfile /home/juliet/Keyring-Tetrahedron.key"
    '';
  };
}
