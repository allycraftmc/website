{
  description = "AllyCraft Website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      src = pkgs.lib.cleanSource self;
    in
    {
      packages.${system} = {
        default = pkgs.stdenv.mkDerivation {
          name = "allycraft-website";
          inherit src;
          buildInputs = [ pkgs.hugo ];
          buildPhase = ''
            runHook preBuild

            hugo --gc --minify

            runHook postBuild
          '';
          installPhase = ''
            cp -r public $out
          '';
        };
        devShells.${system} = {
          default = pkgs.mkShell { builtInputs = [ pkgs.hugo ]; };
        };
      };
    };
}
