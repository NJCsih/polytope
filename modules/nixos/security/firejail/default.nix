# Stolen from Nazarick: https://github.com/DarkKronicle/nazarick/blob/36821871ca8b98628bfac6b54ca8027a2e77ba45/modules/home/security/firejail/default.nix#L1-L62
# I just have it always run

{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = {
    # Make sure system level firejail is enabled
    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        brave = {
          executable = "${pkgs.brave}/bin/brave";
          profile = "${pkgs.firejail}/etc/firejail/brave.profile";
          extraArgs = [
            "--ignore=no-root"
            #"--browser-allow-drm=yes"
            ''--ignore=noexec ''${HOME}''
            ''--ignore=noexec ''${RUNUSER}''
            "--dbus-user.own=org.mpris.MediaPlayer2.plasma-browser-integration"
            "--dbus-user.talk=org.kde.JobViewServer"
            "--dbus-user.talk=org.kde.kuiserver"
            "--dbus-user.talk=org.freedesktop.portal.Desktop"
            "--dbus-user.talk=org.freedesktop.portal.Desktop"
          ];
        };
        firefox = {
          executable = "${pkgs.firefox}/bin/firefox";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
          extraArgs = [
            "--ignore=no-root"
            #"--browser-allow-drm=yes"
            ''--ignore=noexec ''${HOME}''
            ''--ignore=noexec ''${RUNUSER}''
            ''--whitelist=''${HOME}/.config/tridactyl''
            "--dbus-user.own=org.mpris.MediaPlayer2.plasma-browser-integration"
            "--dbus-user.talk=org.kde.JobViewServer"
            "--dbus-user.talk=org.kde.kuiserver"
            "--dbus-user.talk=org.freedesktop.portal.Desktop"
            "--dbus-user.talk=org.freedesktop.portal.Desktop"
          ];
        };
        # HD2 don't work :(
        # steam = {
        # executable = "${pkgs.steam}/bin/steam";
        # profile = "${pkgs.firejail}/etc/firejail/steam.profile";
        # };
        # steam-run = {
        # executable = "${pkgs.steam}/bin/steam-run";
        # profile = "${pkgs.firejail}/etc/firejail/steam.profile";
        # };
      };
    };
  };
}
