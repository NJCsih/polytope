{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  mdadmconfigfile = ''
   # ARRAY /dev/md127 level=raid5 num-devices=4 metadata=1.2 UUID=e4329e79:b9f4456f:ba33392e:48db946f
   # devices=ata-INTEL_SSDSC2BB480G4_BTWL329005ME480QGN-part2,ata-INTEL_SSDSC2BB480G4_BTWL330106RW480QGN-part2,ata-INTEL_SSDSC2BB480G4_BTWL330201LQ480QGN-part2,ata-INTEL_SSDSC2BB480G4_BTWL3335010X480QGN-part2
   # ARRAY /dev/md126 level=raid1 num-devices=3 metadata=1.2 UUID=0f7f0286:d3228196:553e1da4:9f310130
   #    devices=/dev/sda1,/dev/sdb1,/dev/sdd1
  ARRAY /dev/md126 metadata=1.2 UUID=e4329e79:b9f4456f:ba33392e:48db946f # raid5
  ARRAY /dev/md127 metadata=1.2 UUID=0f7f0286:d3228196:553e1da4:9f310130 # raid1
  '';
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Establish raids
  #boot.initrd.services.swraid.enable = {
  boot.swraid = {
    enable = true;
    mdadmConf = mdadmconfigfile;
  };
  environment.etc = { "mdadm.conf".text = mdadmconfigfile; };


  # Luks devices
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/c6f71789-640b-4035-8093-bd28044c7207";
  #boot.initrd.luks.devices."cryptvault".device = "/dev/disk/by-uuid/1b13dd53-9f3a-4580-b960-09a2b472f860";

  # Filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a55a1d94-03ab-4080-be60-c2bae6fafa81";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/a55a1d94-03ab-4080-be60-c2bae6fafa81";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/a55a1d94-03ab-4080-be60-c2bae6fafa81";
    fsType = "btrfs";
    options = [
      "subvol=@persist"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/a55a1d94-03ab-4080-be60-c2bae6fafa81";
    fsType = "btrfs";
    options = [
      "subvol=@swap"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/a55a1d94-03ab-4080-be60-c2bae6fafa81";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
    ];
  };

##fileSystems."/vault" = {
##  device = "/dev/disk/by-uuid/8fd7aafd-419d-4216-9e9e-4dad90e32724";
##  fsType = "btrfs";
##  options = [
##    "compress=zstd"
##    "noatime"
##  ];
##};

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/30C6-AE42";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
