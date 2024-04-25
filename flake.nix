{
  description = "migrator";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bleepSrc.url = "github:KristianAN/bleep-flake"; # The bleep flake
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , bleepSrc
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (f: p: {
              bleep = bleepSrc.defaultPackage.${system};
            })
          ];
        };


        jdk = pkgs.temurin-bin-21;

        jvmInputs = with pkgs; [
          jdk
          bleep
        ];

        jvmHook = ''
          export JAVA_HOME=${jdk}
        '';
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
