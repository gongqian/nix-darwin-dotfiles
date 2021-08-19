{
  nixConfig.extra-substituters = "https://emacsng.cachix.org";
  nixConfig.extra-trusted-public-keys = "emacsng.cachix.org-1:i7wOr4YpdRpWWtShI8bT6V7lOTnPeI7Ho6HaZegFWMI=";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    emacsNg-src.url = "github:emacs-ng/emacs-ng";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };
  outputs = { nixpkgs, emacsNg-src, emacs-overlay, ... }@inputs: {
    nixosConfigurations = {
      shaunsingh-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { _module.args = inputs; }
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              emacs-overlay.overlay
            ];
          })
        ];
      };
    };
  };
}
