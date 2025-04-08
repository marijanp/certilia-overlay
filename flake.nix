{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    let
      withPkgs =
        pkgsCallback:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          let
            pkgs = import nixpkgs {
              config.allowUnfree = true;
              inherit system;
              overlays = [ (import ./overlay.nix) ];
            };
          in
          pkgsCallback pkgs
        );
    in
    {
      overlays.default = import ./overlay.nix;
      packages = withPkgs (pkgs: {
        inherit (pkgs) certilia;
        default = self.packages.${pkgs.system}.certilia;
      });
    };
}
