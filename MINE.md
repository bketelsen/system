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

* [-] Home Manager Linux
* *  [ ] neovim from AstroVim
* [ ] Home Manager Darwin
* [ ] NixOS System(s)
* [ ] Cloud Instances
* [ ] Development VM
