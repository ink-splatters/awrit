{ pkgs, common, ... }:
let inherit (pkgs.llvmPackages) stdenv;
in {

  default = stdenv.mkDerivation {

    src = ./.;

    cmakeFlags = [ ];

    buildPhase = ''
      mkdir build
      cmake -GNinja -DCMAKE_BUILD_TYPE=Release -S . -B build
      cmake --build build
    '';

    installPhase = ''
      mkdir -p $out
      cmake --install build --prefix=$out
    '';

    enableParallelBuilding = true;

  } // common;

}
