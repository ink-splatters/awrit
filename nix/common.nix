{ pkgs, lib, stdenv, bintools, libcxx, system, ... }:
with pkgs;
let

  inherit (darwin.apple_sdk) frameworks;

in rec {
  name = "awrit";

  CFLAGS = "-O3"
    + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs = [ cmake ninja gitMinimal clang_17 libcxx bintools lld_17 ]
    ++ [ (xcodebuild.override{ inherit stdenv;}) ];
  buildInputs = with frameworks; [ Cocoa AppKit ];
}

