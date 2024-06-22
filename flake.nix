{
    description = "NixOS custom installation ISO";
    inputs.nixos.url = "nixpkgs/24.05";
    outputs = { self, nixos }: {
        nixosConfigurations = {
            iso = nixos.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                    ({ lib, pkgs, ... }: let 
                                # TODO: maybe use this in the future
                                # but had storage and memory issues with this before
                                # sudo nix \
                                # run "github:nix-community/disko#disko-install" -- --flake \
                                # "github:wjehee/.dotfiles-nix#$1" --disk main $2
                            disko-format = pkgs.writeShellScriptBin "disko-format" ''
                                sudo nix \
                                run "github:nix-community/disko" -- --mode disko \
                                --flake "github:wjehee/.dotfiles-nix#disko" \
                                --arg disk $1
                            '';
                            install-flake = pkgs.writeShellScriptBin "install-flake" ''
                                git clone https://github.com/wjehee/.dotfiles-nix
                                nixos-generate-config --no-filesystems
                                cp /etc/nixos/hardware-configuration.nix ".dotfiles-nix/hosts/$1/"
                                nixos-install --flake ".dotfiles-nix#$1"
                            '';
                    in {
                        nix.settings.experimental-features = [
                            "nix-command"
                            "flakes"
                        ];
                        boot.tmp.useTmpfs = true;
                        isoImage.squashfsCompression = lib.mkDefault "zstd";
                        environment.systemPackages = with pkgs; [
                            disko-format
                            install-flake

                            git
                        ];
                     })
                ];
            };
        };
    };
}
