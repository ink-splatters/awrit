{ pkgs, common, stdenv, ... }: {

  default = stdenv.mkDerivation {

    inherit (common) name CFLAGS CXXFLAGS nativeBuildInputs buildInputs;

    src = ./.;

    cmakeFlags = [ ];

    buildPhase = ''
      mkdir build
      cmake -GNinja -DCMAKE_BUILD_TYPE=Release -S $src -B build
      cmake --build build
    '';

    installPhase = ''
      mkdir -p $out
      cmake --install build --prefix=$out
    '';

    LDFLAGS=common.LDFLAGS + " -L$src/tbd";

    enableParallelBuilding = true;

  };

}
