{ inputs, config, pkgs, ... }: {
  homebrew = {
    enable = true;
    autoUpdate = false;
    global = {
      brewfile = true;
      noLock = true;
    };
    brews = [
      "awscli"
    ];

    taps = [
      "1password/tap"
      "beeftornado/rmtree"
      "cloudflare/cloudflare"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
      "teamookla/speedtest"

    ];
    casks = [
      "1password-cli"
      "alt-tab"
      "appcleaner"
      "bartender"
      "firefox-developer-edition"
      "gpg-suite"
      "kitty"
      "lxc"
      "obsidian"
      "raycast"
      "stats"
    ];
  };
}
