# Nix install

Installing [my dotfiles](https://github.com/WJehee/.dotfiles-nix) using this image.

1. Become root `sudo su`
2. Create the password for full disk encryption: `echo "MY_PASSWORD" > /tmp/secret.key`
3. `disko-format /PATH/TO/DISK`
4. `install-flake HOSTNAME`
5. Set root passwd after being prompted

After the install has finished, do the following:  
```sh
nixos-enter --root /mnt
passwd USERNAME
exit
reboot
```

