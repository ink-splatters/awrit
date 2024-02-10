{ pkgs, common, self, system }:
let inherit (pkgs) llvmPackages mkShell;
in {

  default = mkShell.override { inherit (llvmPackages) stdenv; } {

    inherit (common) name CFLAGS CXXFLAGS LDFLAGS nativeBuildInputs;

    shellHook = ''
      export PS1="\n\[\033[01;36m\]‹⊂˖˖› \\$ \[\033[00m\]"
      echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
    '';
  };

  install-hooks =
    mkShell { inherit (self.checks.${system}.pre-commit-check) shellHook; };
}

