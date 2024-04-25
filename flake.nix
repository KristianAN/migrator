{
  description = "migrator";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let

        bleepSrc = import ./bleep.nix { flake-utils = flake-utils; pkgs = pkgs; };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (f: p: {
              scala-cli = p.scala-cli.override { jre = p.temurin-bin-17; };
              bleep = bleepSrc.defaultPackage.${system}; # Your bleep system binary
            })
          ];
        };


        jdk = pkgs.temurin-bin-17;

        jvmInputs = with pkgs; [
          jdk
          scala-cli
          bleep
        ];

        jvmHook = '''';
      in
      {
        devShells.default = pkgs.mkShell {
          name = "migrator-dev-shell";
          buildInputs = jvmInputs;
          shellHook = jvmHook;
        };
      }
    );
}
