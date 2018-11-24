
{ systemNixpkgs ? import <nixpkgs> {}
}:

let
  inherit (systemNixpkgs) fetchgit;
    nixpkgsPath = fetchgit (import ./etc/version.nix);
    nixpkgs = import nixpkgsPath {
      config.allowUnfree = true;
    };
  inherit (nixpkgs) stdenv;
  python-packages = python-packages: with python-packages; [
    numpy
    six
    tensorflow
    
  ]; 
  python-with-packages = nixpkgs.python36Full.withPackages python-packages;

in stdenv.mkDerivation {
  name = "tensor";
  buildInputs = with nixpkgs; [
    python-with-packages
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgsPath}:nixos=${nixpkgsPath}/nixos"
    export TMPDIR="$(mktemp -d /tmp/XXXXXXXXXX)"
  '';
}
