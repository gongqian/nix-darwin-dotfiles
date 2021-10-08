{
  description = "Shaurya's Nix Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    mk-darwin-system.url = "github:vic/mk-darwin-system/main";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, mk-darwin-system, emacs-overlay, neovim, ... }@inputs: 
    let
      flake-utils = mk-darwin-system.inputs.flake-utils;
      hostName = "shaunsingh-laptop";
      systems = [ "aarch64-darwin" ];

    in flake-utils.lib.eachSystem systems (system:
      mk-darwin-system.mkDarwinSystem {
        inherit hostName system;
        nixosModules = [
          ./modules/emacs.nix
          ./modules/git.nix
          ./modules/pam.nix
          ./modules/homebrew.nix
          ({ pkgs, lib, ... }: {
            system.stateVersion = 4;

            system.keyboard = {
              enableKeyMapping = true;
              remapCapsLockToEscape = true;
            };

            system.defaults = {
              screencapture = {
                  location = "/tmp";
              };
              dock = {
                autohide = true;
                showhidden = true;
                mru-spaces = false;
              };
              finder = {
                AppleShowAllExtensions = true;
                QuitMenuItem = true;
                FXEnableExtensionChangeWarning = true;
              };
              NSGlobalDomain = {
                AppleInterfaceStyle = "Dark";
                AppleKeyboardUIMode = 3;
                ApplePressAndHoldEnabled = false;
                AppleFontSmoothing = 1;
                _HIHideMenuBar = true;
                InitialKeyRepeat = 10;
                KeyRepeat = 1;
                "com.apple.mouse.tapBehavior" = 1;
                "com.apple.swipescrolldirection" = true;
              };
            };

            security.pam.enableSudoTouchIdAuth = true;

            programs.fish.enable = true;
            environment.shells = with pkgs; [ fish ];
            users.users.shauryasingh = {
              home = "/Users/shauryasingh";
              shell = pkgs.fish;
            };
            system.activationScripts.postActivation.text = ''
              # Set the default shell as fish for the user
              sudo chsh -s ${lib.getBin pkgs.fish}/bin/fish shauryasingh 
            '';

            services.nix-daemon.enable = true;
            programs.tmux.enable = true;
          
            nixpkgs = {
              overlays = [
                emacs-overlay.overlay
                neovim.overlay
              ];
              config.allowUnfree = true;
            };

            nix = {
              package = pkgs.nixUnstable;
              extraOptions = ''
                system = aarch64-darwin
                extra-platforms = aarch64-darwin x86_64-darwin
                experimental-features = nix-command flakes
                build-users-group = nixbld
              '';
            };

            fonts = {
              enableFontDir = true;
              fonts = with pkgs; [
                overpass
                alegreya
              ];
            };

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.shauryasingh.home.packages = with pkgs; [
                # Dotfiles Management
                yadm
              
                # Utils
                wget
                git-lfs
                exa
                bat
                tree

                # Browsers
                ## firefox
                ## nyxt
                ## qutebrowser

                # Neovim
                neovim
                ## neovide
              
                # Chat
                discocss
              ];
            };
          })
        ];

        flakeOutputs = { pkgs, ... }@outputs:
          outputs // (with pkgs; { packages = { inherit hello; }; });
     });
}
