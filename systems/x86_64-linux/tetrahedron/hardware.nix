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
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/095b7088-e16b-45c8-ba08-0606cd87a054";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/backups" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "subvol=@backups"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "subvol=@media"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "subvol=@persist"
      "compress=zstd"
      "noatime"
    ];
    # neededForBoot = true;
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "subvol=@swap"
      "noatime"
    ];
    # neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "subvol=@newhome"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/mnt/driveroot" = {
    device = "/dev/disk/by-uuid/d05ebcdc-704d-4c22-8666-df6e17e2276c";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/18B3-D43A";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # sudo mount -o uid=1000,gid=100,rw,user,exec,umask=000,noauto,windows_names -t ntfs /dev/sda2 /mnt/fluder
  fileSystems."/winDrive" = {
    device = "/dev/disk/by-uuid/";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec"
      "umask=000"
      "noauto"
      "windows_names"
      # "nofail" -- we want it to complain if there's an issue, just to noauto on startup
      "noauto" # Is this the right one? -- just dont automatically mount, but I want it in fstab
    ];
  };
  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  # Nvidia driver setup:
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      vaapiVdpau
    ];
  };

  hardware.nvidia = {

    modesetting.enable = true; # Modesetting is required.

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    powerManagement.enable = true; # We can now do this woo

    open = true; # Use open kernel, (this is not nouveau), only some cards supported

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # set IDs and prime offloading
    prime = {
      intelBusId = "PCI:0:2:0";
      # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
      nvidiaBusId = "PCI:1:0:0";

      sync.enable = true;

      #offload = {
      #  # I'm gonna try without offloading
      #  enable = false;
      #  enableOffloadCmd = false;
      #};
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
