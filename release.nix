let
  flakeLock = builtins.fromJSON (builtins.readFile ./flake.lock);
  pkgsSrc = fetchTarball {
    url =
      flakeLock.nodes.nixpkgs.locked.url
        or "https://github.com/NixOS/nixpkgs/archive/${flakeLock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = flakeLock.nodes.nixpkgs.locked.narHash;
  };
  pkgs = import pkgsSrc {
    config.allowUnfree = true;
    overlays = [ (import ./overlay.nix) ];
  };
in
{
  inherit (pkgs) certilia;
}
