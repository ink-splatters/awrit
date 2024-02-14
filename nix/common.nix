{ pkgs, lib, llvmPackages, system, ... }:
let

  replaceStdenv = pkg:
    pkg.overrideAttrs (_: { inherit (llvmPackages) stdenv; });

  inherit (pkgs.darwin.apple_sdk) frameworks impure-deps;

in rec {

  name = "awrit";

  CFLAGS = "-O3"
    + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS="";
  # LDFLAGS = "-L/usr/lib -fuse-ld=lld  ";

  nativeBuildInputs = with pkgs;
      [ ccache cmake ninja gitMinimal cacert]
    # lld ]
    ++ [ (replaceStdenv pkgs.xcodebuild) ];

  buildInputs = with frameworks;[ Cocoa AppKit ];
}
