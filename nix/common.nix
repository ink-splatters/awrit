{ pkgs, lib, system, ... }:
let

  inherit (pkgs.darwin.apple_sdk) frameworks;

in rec {
  name = "awrit";

  CFLAGS = "-O3"
    + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs = with pkgs; [ cmake ninja gitMinimal lld ];
  buildInputs = with frameworks; [ Cocoa AppKit ];
}
