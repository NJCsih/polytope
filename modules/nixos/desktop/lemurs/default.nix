{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{

  # Start the service to run it
  services.displayManager = {
    enable = true;
    execCmd = lib.mkForce "exec /run/current-system/sw/bin/lemurs";
  };

  # Config file
  environment.etc."lemurs/config.toml".source = pkgs.writeTextFile {
    name = "lemursConfig";
    text = builtins.readFile ./config.toml;
    executable = false;
  };

  # sway entry
  environment.etc."lemurs/wayland/Sway.sh".source = pkgs.writeTextFile {
    name = "lemursSwayEntry";
    text = ''
      #! /bin/sh
      exec sway --unsupported-gpu
    '';
    executable = true;
  };

  # Create a systemd service to run it
  # https://search.nixos.org/options?channel=unstable&show=systemd.services.%3Cname%3E.serviceConfig&from=0&size=50&sort=relevance&type=packages&query=systemd.services.%3Cname%3E.
  # systemd.user.services.lemurs = {
  #   enable = true;
  #   description = "Lemurs";
  #   #after = systemd-user-sessions.service plymouth-quit-wait.service;
  #   #after = "getty@tty2.service";
  #   serviceConfig = {
  #     # ExecStart=/usr/bin/lemurs
  #     ExecStart = "${pkgs.lemurs}/bin/lemurs";
  #     ExecStop = "pkill lemurs";
  #     # StandardInput=tty
  #     #StandardInput = tty;
  #     # TTYPath=/dev/tty2
  #     TTYPath = /dev/tty2;
  #     # TTYReset=yes
  #     #TTYReset = yes;
  #     # TTYVHangup=yes
  #     #TTYVHangup = yes;
  #     # Type=idle
  #     #Type = idle;
  #     Type = "forking";
  #     Restart = "on-failure";
  #   };
  #   wantedBy = [ "default.target" ];
  # };

  # systemd.user.services.nm-applet = {
  #   description = "Network manager applet";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     Environment = [ "DISPLAY=:1" ];
  #     ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  #   };
  # };

  # [Unit]
  # Description=Lemurs
  # After=systemd-user-sessions.service plymouth-quit-wait.service
  # After=getty@tty2.service
  # 
  # [Service]
  # ExecStart=/usr/bin/lemurs
  # StandardInput=tty
  # TTYPath=/dev/tty2
  # TTYReset=yes
  # TTYVHangup=yes
  # Type=idle
  # 
  # [Install]
  # Alias=display-manager.service
}
