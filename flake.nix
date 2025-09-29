{
  description = "hello-haskell";

  inputs = {
    # Nix Inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: 
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: function rec {
          inherit system;
          compilerVersion = "ghc984";
          pkgs = nixpkgs.legacyPackages.${system};
          hsPkgs = pkgs.haskell.packages.${compilerVersion}.override {
            overrides = hfinal: hprev: {
              hello-haskell = hfinal.callCabal2nix "hello-haskell" ./. {};
            };
          };
        });
    in
    {
      # nix fmt
      formatter = forAllSystems ({pkgs, ...}: pkgs.alejandra);

      # nix develop
      devShell = forAllSystems ({hsPkgs, pkgs, ...}:
        hsPkgs.shellFor {
          # withHoogle = true;
          packages = p: [
            p.hello-haskell
          ];
          buildInputs = with pkgs;
            [
              hsPkgs.haskell-language-server
              haskellPackages.cabal-install
              cabal2nix
              haskellPackages.ghcid
              haskellPackages.fourmolu
              haskellPackages.cabal-fmt
            ]
            ++ (builtins.attrValues (import ./scripts.nix {s = pkgs.writeShellScriptBin;}));
        });

      # nix build
      packages = forAllSystems ({hsPkgs, ...}: {
          hello-haskell = hsPkgs.hello-haskell;
          default = hsPkgs.hello-haskell;
      });

      # You can't build the hello-haskell package as a check because of IFD in cabal2nix
      checks = {};

      # nix run
      apps = forAllSystems ({system, ...}: {
        hello-haskell = { 
          type = "app"; 
          program = "${self.packages.${system}.hello-haskell}/bin/hello-haskell"; 
        };
        default = self.apps.${system}.hello-haskell;
      });
    };
}
