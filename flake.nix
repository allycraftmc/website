{
  description = "AllyCraft Website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    src = ./.;
    theme = pkgs.buildNpmPackage {
        pname = "hugo-theme";
        version = "v0.0.1";
        src = "${src}/themes/hugo-theme";
        npmDepsHash = "sha256-OZLRXD8cRg/8bL8YTz3mqBkWfmf4MFLA4+wRcwrt/Jw=";
        dontNpmBuild = true;

        installPhase = ''
        runHook preInstall
        cp -r . "$out"
        runHook postInstall
        '';
      };
  in {
    packages.${system} =  rec {
      default = pkgs.stdenv.mkDerivation {
        name = "allycraft-website";
        inherit src;
        buildInputs = [pkgs.hugo pkgs.nodejs];
        buildPhase = ''
          runHook preBuild

          ln -s ${theme}/node_modules node_modules
          export PATH="$PATH:$PWD/themes/hugo-theme/node_modules/.bin"
          hugo --gc --minify

          runHook postBuild
        '';
        installPhase = ''
          cp -r public $out
        '';
      };
      
    };
  };
}
