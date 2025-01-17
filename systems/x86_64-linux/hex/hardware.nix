# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
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
    "ehci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/6c54c068-24e0-4092-9272-22933df6a24d";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4a7a74e0-8a17-4925-bbc2-850cc9d63abc";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/4a7a74e0-8a17-4925-bbc2-850cc9d63abc";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/4a7a74e0-8a17-4925-bbc2-850cc9d63abc";
    fsType = "btrfs";
    options = [
      "subvol=@persist"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/4a7a74e0-8a17-4925-bbc2-850cc9d63abc";
    fsType = "btrfs";
    options = [
      "subvol=@swap"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/4a7a74e0-8a17-4925-bbc2-850cc9d63abc";
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
    device = "/dev/disk/by-uuid/B9B7-FB7C";
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
    powerManagement.enable = false; # Can cause crashes after waking from sleep

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # THIS BREAKS EVERYTHING NO TOUCHING
    open = false; # Use open kernel, (this is not nouveau), only some cards supported

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # set IDs and prime offloading
    prime = {
      intelBusId = "PCI:0:2:0";
      # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
      nvidiaBusId = "PCI:1:0:0";

      sync.enable = false; # Unsupported on older cards ig?

      offload = {
        # I'm gonna try without offloading
        enable = false;
        enableOffloadCmd = false;
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
