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
      "lxc"
    ];

    taps = [
      "1password/tap"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
    ];
    casks = [
      "1password-cli"
      "appcleaner"
      "firefox-developer-edition"
      "gpg-suite"
      "stats"
    ];
  };
}
