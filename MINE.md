## bootstrap

ssh thopter
cd .ssh/
scp thopter:~/.ssh/id_rsa .
scp thopter:~/.ssh/id_rsa.pub .

git clone https://github.com/bketelsen/system ~/.nixpkgs

cd .nixpkgs/
./bin/install-nix.sh
exit/reboot
cd .nixpkgs/
nix --extra-experimental-features "nix-command flakes" develop -c sysdo bootstrap --home-manager server

## Roles

### Server
mac/linux workstation setup

## Port Status

* [x] Home Manager Linux
* *  [x] neovim from AstroVim
* [x] Home Manager Darwin
* [ ] NixOS System(s)
* [ ] Cloud Instances
* [ ] Development VM

# Nixinate

nix run .#apps.nixinate.kaitain