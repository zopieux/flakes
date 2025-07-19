{
  description = "A Go development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      goVersion = 24;
      overlays = [ (final: prev: { go = prev."go_1_${toString goVersion}"; }) ];
      supportedSystems = [ "x86_64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            go
            gotools
            golangci-lint
            gopls
            godef
            go-outline
          ];
        };
      });
    };
}
