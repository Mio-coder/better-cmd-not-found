{
  description = "Interactive command-not-found handler with fuzzy selection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, ... } @ inputs: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      devenv-up = self.devShells.${system}.default.config.procfileScript;
      devenv-test = self.devShells.${system}.default.config.test;
      
      default = pkgs.rustPlatform.buildRustPackage {
        pname = "better-cmd-not-found";
        version = "0.1.0";
        src = ./.;

        cargoLock.lockFile = ./Cargo.lock;

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ 
          pkgs.nix-index
        ];

        postInstall = ''
          mkdir -p $out/etc/profile.d
          substitute ${./setup.sh} $out/etc/profile.d/setup-cmd-not-found.sh \
            --subst-var out
        '';
      };
    };

    devShells.${system}.default = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ({ pkgs, ... }: {
          languages.rust.enable = true;
          git-hooks.hooks.clippy.enable = true;
          packages = [ pkgs.nix-index ];
        })
      ];
    };

    nixosModules.default = { ... }: {
      environment.etc."profile.d/setup-cmd-not-found.sh".source = 
        "${self.packages.${system}.default}/etc/profile.d/setup-cmd-not-found.sh";
    };
  };
}
