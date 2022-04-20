{
  description = "Shaurya's Nix Environment";

  inputs = {
    # All packages should follow latest nixpkgs/nur
    unstable.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    # Nix-Darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "unstable";
    };
    # NixOS Hardware for thinkpad config
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "unstable";
    };
    # HM-manager for dotfile/user management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    # Bar (macos)
    spacebar = {
      url = "github:shaunsingh/spacebar";
      inputs.nixpkgs.follows = "unstable";
    };
    # WM
    yabai-src = {
      url = "github:koekeishiya/yabai";
      flake = false;
    };
    # SRC for macOS emacs overlay
    emacs-src = {
      url = "github:emacs-mirror/emacs";
      flake = false;
    };
    # SRC for linux emacs overlay
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
    # Use latest libverm to build macOS emacs build
    emacs-vterm-src = {
      url = "github:akermu/emacs-libvterm";
      flake = false;
    };
    # Keep the doom-emacs version managed with nix config
    doom-emacs = {
      url = "github:hlissner/doom-emacs";
      flake = false;
    };
    # Themeing
    base16 = {
      url = "github:shaunsingh/base16.nix";
      inputs.nixpkgs.follows = "unstable";
    };
    # IBM-Carbon-Theme (see IBM-design: colors)
    base16-carbon-dark = {
      url = "github:shaunsingh/base16-carbon-dark";
      flake = false;
    };
    # Neovim Nightly
    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "unstable";
    };
    # Get the latest and greatest wayland tools
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "unstable";
    };
    # But sway is special :)
    sway-borders-src = {
      url = "github:fluix-dev/sway-borders";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs: {
    darwinConfigurations."geek-laptop" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./modules/mac.nix
        ./modules/pam.nix
        ./modules/editors.nix
        home-manager.darwinModule
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit (inputs)
                base16-carbon-dark; # pass base16 input so hm can use it
            };
            users.geek = {
              imports = [
                inputs.base16.hmModule
                ./modules/home.nix
                ./modules/theme.nix
              ];
            };
          };
        }
        ({ config, pkgs, lib, ... }: {
          services.nix-daemon.enable = true;
          security.pam.enableSudoTouchIdAuth = true;
          nixpkgs = {
            overlays = with inputs; [
              nur.overlay
              spacebar.overlay
              neovim-overlay.overlay
              (final: prev: {
                doomEmacsRevision = inputs.doom-emacs.rev;
                sf-mono-liga-bin = pkgs.callPackage ./pkgs/sf-mono-liga-bin { };
                # nyxt = pkgs.callPackage ./pkgs/nyxt { };
                # yabai is broken on macOS 12, so lets make a smol overlay to use the master version
                yabai = let
                  version = "4.0.0-dev";
                  buildSymlinks = prev.runCommand "build-symlinks" { } ''
                    mkdir -p $out/bin
                    ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
                  '';
                in prev.yabai.overrideAttrs (old: {
                  inherit version;
                  src = inputs.yabai-src;

                  buildInputs = with prev.darwin.apple_sdk.frameworks; [
                    Carbon
                    Cocoa
                    ScriptingBridge
                    prev.xxd
                    SkyLight
                  ];

                  nativeBuildInputs = [ buildSymlinks ];
                });
                emacs-vterm = prev.stdenv.mkDerivation rec {
                  pname = "emacs-vterm";
                  version = "master";

                  src = inputs.emacs-vterm-src;

                  nativeBuildInputs = [ prev.cmake prev.libtool prev.glib.dev ];

                  buildInputs =
                    [ prev.glib.out prev.libvterm-neovim prev.ncurses ];

                  cmakeFlags = [ "-DUSE_SYSTEM_LIBVTERM=yes" ];

                  preConfigure = ''
                    echo "include_directories(\"${prev.glib.out}/lib/glib-2.0/include\")" >> CMakeLists.txt
                    echo "include_directories(\"${prev.glib.dev}/include/glib-2.0\")" >> CMakeLists.txt
                    echo "include_directories(\"${prev.ncurses.dev}/include\")" >> CMakeLists.txt
                    echo "include_directories(\"${prev.libvterm-neovim}/include\")" >> CMakeLists.txt
                  '';

                  installPhase = ''
                    mkdir -p $out
                    cp ../vterm-module.so $out
                    cp ../vterm.el $out
                  '';

                };
                emacs = (prev.emacs.override {
                  srcRepo = true;
                  nativeComp = true;
                  withSQLite3 = true;
                  withXwidgets = true;
                }).overrideAttrs (o: rec {
                  version = "29.0.50";
                  src = inputs.emacs-src;

                  buildInputs = o.buildInputs
                    ++ [ prev.darwin.apple_sdk.frameworks.WebKit ];

                  configureFlags = o.configureFlags ++ [
                    "--without-gpm"
                    "--without-dbus"
                    "--without-mailutils"
                    "--without-toolkit-scroll-bars"
                    "--without-pop"
                  ];

                  patches = [
                    ./patches/fix-window-role.patch
                    ./patches/system-appearance.patch
                    # ./patches/no-titlebar.patch
                  ];

                  postPatch = o.postPatch + ''
                    substituteInPlace lisp/loadup.el \
                    --replace '(emacs-repository-get-branch)' '"master"'
                  '';

                  postInstall = o.postInstall + ''
                    cp ${final.emacs-vterm}/vterm.el $out/share/emacs/site-lisp/vterm.el
                    cp ${final.emacs-vterm}/vterm-module.so $out/share/emacs/site-lisp/vterm-module.so
                  '';

                  CFLAGS =
                    "-DMAC_OS_X_VERSION_MAX_ALLOWED=110203 -g -O3 -mtune=native -march=native -fomit-frame-pointer";
                });
              })
            ];
          };
        })
      ];
    };
    nixosConfigurations = {
      geek-thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hardware/thinkpad-hardware-configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
          ./modules/editors.nix
          ./modules/linux.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit (inputs) base16-carbon-dark; # see: theme.nix
              };
              users.geek = {
                imports = [
                  inputs.base16.hmModule
                  ./modules/home.nix
                  ./modules/theme.nix
                  ./modules/sway.nix
                ];
              };
            };
          }
          ({ config, pkgs, lib, ... }: {
            # Configure overlays
            nixpkgs = {
              overlays = with inputs; [
                nur.overlay
                neovim-overlay.overlay
                emacs-overlay.overlay
                nixpkgs-wayland.overlay
                (final: prev: {
                  doomEmacsRevision = inputs.doom-emacs.rev;
                  sf-mono-liga-bin =
                    pkgs.callPackage ./pkgs/sf-mono-liga-bin { };
                  sway-borders = let version = "1.8-borders-dev";
                  in prev.sway.overrideAttrs (old: {
                    inherit version;
                    src = inputs.sway-borders-src;
                    CFLAGS = prev.CFLAGS
                      ++ "-Wno-error"; # regular build fails because of warnings treated as errors. Disabled for now
                  });
                })
              ];
            };

            # Power management
            services.tlp.enable = true; # keep my ports controlle
            services.thermald.enable = true; # keep my battery controlled
            powerManagement.cpuFreqGovernor =
              lib.mkDefault "powersave"; # keep my cpu frequency controlled

            # Network settings.
            networking = {
              hostName = "geek-thinkpad"; # Hostname
              useDHCP = false; # Deprecated, so set explicitly to false
              wireless.enable = false;
              networkmanager.enable = true;
              firewall.enable = false; # I had issues, for some reason
            };

          })
        ];
      };
    };
  };
}
