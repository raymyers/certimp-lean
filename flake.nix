{
  description = "CertIMP — a certified IMP compiler & verification framework in Lean 4";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          # `elan` manages the Lean toolchain pinned in `lean-toolchain`,
          # and bundles `lake`. `lake exe cache get` pulls Mathlib's
          # prebuilt oleans so a full source build isn't required.
          packages = [
            pkgs.elan
            pkgs.git
            pkgs.curl
          ];

          shellHook = ''
            echo "CertIMP dev shell — run 'lake exe cache get' then 'lake build'."
          '';
        };
      });
}
