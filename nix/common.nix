{ pkgs, lib, system, ... }:
with pkgs;
let

  inherit (darwin.apple_sdk) frameworks;

  replaceStdenv = pkg:
    pkg.overrideAttrs (_: { inherit (llvmPackages) stdenv; });

in rec {
  name = "awrit";

  CFLAGS = "-O3"
    + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs = [ cmake ninja gitMinimal lld ]
    ++ [ (replaceStdenv xcodebuild) ];
  buildInputs = with frameworks; [ Cocoa AppKit ];
}

