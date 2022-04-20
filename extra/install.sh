#!/bin/bash
sh <(curl -L https://nixos.org/nix/install)

nix-shell -p nixUnstable git emacs

git clone --depth 1 https://github.com/shaunsingh/nix-darwin-dotfiles.git ~/nix-darwin-dotfiles/ && cd nix-darwin-dotfiles
emacs --batch --eval "(progn (require 'org) (setq org-confirm-babel-evaluate nil) (org-babel-tangle-file \"~/nix-darwin-dotfiles/nix-config.org\"))"
emacs --batch --eval "(progn (require 'org) (setq org-confirm-babel-evaluate nil) (org-babel-tangle-file \"~/nix-darwin-dotfiles/configs/doom/config.org\"))"

nix build ~/nix-darwin-dotfiles\#darwinConfigurations.geek-laptop.system --extra-experimental-features nix-command --extra-experimental-features flakes
./result/sw/bin/darwin-rebuild switch --flake .#geek-laptop

git clone --depth 1 https://github.com/shaunsingh/nyoom.emacs ~/.config/doom

git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.config/emacs
~/.config/emacs/bin/doom install

git clone --depth 1 https://github.com/shaunsingh/nyoom.nvim.git ~/.config/nvim 
nvim