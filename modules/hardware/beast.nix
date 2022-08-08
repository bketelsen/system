# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      (modulesPath + "/installer/scan/not-detected.nix")
       ./zfs.nix
    ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  networking.hostName = "beast"; # Define your hostname.

  fileSystems."/" =
    { device = "rpool/nixos/root";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/home" =
    { device = "rpool/nixos/home";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/var/lib" =
    { device = "rpool/nixos/var/lib";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/var/log" =
    { device = "rpool/nixos/var/log";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/boot" =
    { device = "bpool/nixos/root";
      fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];
    };

  fileSystems."/boot/efis/nvme-Samsung_SSD_980_PRO_1TB_S5P2NG0R914459M-part1" =
    { device = "/dev/disk/by-uuid/5D2B-7A3F";
      fsType = "vfat";
    };

  fileSystems."/boot/efi" =
    { device = "/boot/efis/nvme-Samsung_SSD_980_PRO_1TB_S5P2NG0R914459M-part1";
      fsType = "none";
      options = [ "bind" ];
    };

  swapDevices = [ ];

  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges = {
  "br0" = {
    interfaces = [ "enp6s0" ];
  };
  };


  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
