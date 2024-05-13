{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4bc5977b-3fdc-4c18-bf96-6e449b66b77c";
      fsType = "btrfs";
      options = [ 
        "subvol=@" 
        "compress=zstd" 
        "noatime" 
      ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/ffcffdaa-b18e-412e-b9b2-62b57a279fae";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/4bc5977b-3fdc-4c18-bf96-6e449b66b77c";
      fsType = "btrfs";
      options = [ 
        "subvol=@nix" 
        "compress=zstd" 
        "noatime" 
      ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4bc5977b-3fdc-4c18-bf96-6e449b66b77c";
      fsType = "btrfs";
      options = [ 
        "subvol=@home"
        "compress=zstd" 
        "noatime" 
      ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F91C-1C33";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
}
