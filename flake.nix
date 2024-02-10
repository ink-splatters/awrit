{
  description = "basic cpp development shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys =
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};

      in with pkgs; {

        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ../.;
          hooks = {
            clang-format.enable = true;
            clang-tidy.enable = true;
            deadnix.enable = true;
            markdownlint.enable = true;
            nil.enable = true;
            nixfmt.enable = true;
            statix.enable = true;
          };

          tools = pkgs;
        };

        formatter = nixfmt;

        devShells = {

          default = let
            replaceStdenv = pkg:
              pkg.overrideAttrs (_: { inherit (llvmPackages) stdenv; });
          in mkShell.override { inherit (llvmPackages) stdenv; } {
            CXXFLAGS = "-O3 -stdlib=libc++ "
              + lib.optionalString ("${system}" == "aarch64-darwin")
              "-mcpu=apple-m1";

            LDFLAGS = "-fuse-ld=lld -stdlib=libc++";

            nativeBuildInputs = [ ccache cmake ninja lld ]
              ++ [ (replaceStdenv xcodebuild) ];

            shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
              export PS1="\n\[\033[01;36m\]‹⊂˖˖› \\$ \[\033[00m\]"
              echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
            '';

            install-hooks = mkShell {
              inherit (self.checks.${system}.pre-commit-check) shellHook;
            };
          };
        };
      });
}
