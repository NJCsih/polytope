{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ 
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/4d48c9a8-e285-4a16-8d07-f19bab320d9a";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@"
      ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@nix"
      ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@home1"
      ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@swap"
      ];
    };

  fileSystems."/backups" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@backups"
      ];
    };

  fileSystems."/eternal" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@eternal"
      ];
    };

  fileSystems."/media" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@media"
      ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FF33-8900";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

  fileSystems."/mnt/driveroot" =
    { device = "/dev/disk/by-uuid/75deacfa-5eb2-463d-bd98-62f244a669c6";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
      ];
    };

  fileSystems."/mnt/tmpfs" =
    { device = "none";
      fsType = "tmpfs";
      options = [
        "noatime"
        "defaults"
        "size=50%"
        "mode=755"
        "uid=1000"
      ];
    };



  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
