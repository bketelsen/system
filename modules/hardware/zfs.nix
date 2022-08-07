{ config, pkgs, ... }:

{ boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "086a80a5";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
boot.loader.efi.efiSysMountPoint = "/boot/efi";
boot.loader.efi.canTouchEfiVariables = false;
boot.loader.generationsDir.copyKernels = true;
boot.loader.grub.efiInstallAsRemovable = true;
boot.loader.grub.enable = true;
boot.loader.grub.version = 2;
boot.loader.grub.copyKernels = true;
boot.loader.grub.efiSupport = true;
boot.loader.grub.zfsSupport = true;
boot.loader.grub.extraPrepareConfig = ''
  mkdir -p /boot/efis
  for i in  /boot/efis/*; do mount $i ; done

  mkdir -p /boot/efi
  mount /boot/efi
'';
boot.loader.grub.extraInstallCommands = ''
ESP_MIRROR=$(mktemp -d)
cp -r /boot/efi/EFI $ESP_MIRROR
for i in /boot/efis/*; do
 cp -r $ESP_MIRROR/EFI $i
done
rm -rf $ESP_MIRROR
'';
boot.loader.grub.devices = [
      "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5P2NG0R914459M"
    ];

services.zfs = {   
  # These are recommended options for zfs                     
  autoScrub.enable = true;                  
  autoSnapshot.enable = true;               
};
users.users.root.initialHashedPassword = "$6$o7Gbl6VwKt9Fzssj$mfBuXPilRBrvh4.A3c5Uj1XVd1eFF13KOleZwTo0fdmiUjWrplORTgeCboV26nPar8/B2WU0TxirdF/9f54yZ.";
}
