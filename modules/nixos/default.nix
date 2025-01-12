{ config, pkgs, inputs, ... }: {
  # bundles essential nixos modules
  imports = [
    ../common.nix
  ];

  services.syncthing = {
    enable = true;
    user = config.user.name;
    group = "users";
    openDefaultPorts = true;
    dataDir = config.user.home;
    guiAddress = "0.0.0.0:8384";
  };

  services.tailscale = {
    enable = true;
  };
  # enable vs-code server support
  # https://github.com/msteen/nixos-vscode-server


  virtualisation = {
    lxc = {
      enable = true;
      lxcfs.enable = true;
    };
  };

fonts.fonts = with pkgs; [
  (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
];

  environment.systemPackages = with pkgs; [ unzip vscode firefox gnome.gnome-tweaks ];

  hm = { pkgs, ... }: { imports = [ ]; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.bash;
    mutableUsers = false;
    users = {
      "${config.user.name}" = {
        isNormalUser = true;
        extraGroups =
          [ "wheel" "networkmanager" "lxd" "podman" ]; # Enable ‘sudo’ for the user.
        hashedPassword =
          "$6$9WbAMICpXIHb7uuw$cI3/9WhKFWN0/ATSfMwhpQVib5jVWgBmjMaAWgHcO33tvXWFpg2Pg.epG6gz0mhOgVn2vkYgNO.XepgAXIYBK.";
      };
    };
  };

  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = pkgs.jetbrains-mono;
  #   keyMap = "us";
  # };

  # Set your time zone.
  # time.timeZone = "EST";
  #services.geoclue2.enable = true;
  #services.localtimed.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  #	programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #  pinentryFlavor = "gnome3";
  #};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?


}
