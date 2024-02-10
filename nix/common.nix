{ pkgs, lib, llvmPackages, system, ... }:
let

  replaceStdenv = pkg:
    pkg.overrideAttrs (_: { inherit (llvmPackages) stdenv; });

in rec {

  name = "awrit";

  CFLAGS = "-O3"
    + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs = with pkgs;
    [ ccache cmake ninja gitMinimal cacert lld ]
    ++ [ (replaceStdenv pkgs.xcodebuild) ];

  buildInputs = with pkgs.darwin.apple_sdk.frameworks; [ Cocoa AppKit ];
}
