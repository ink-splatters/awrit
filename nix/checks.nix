{ pkgs, pre-commit-hooks, system, ... }: {
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ../.;
    hooks = {
      # clang-format.enable = true;
      # clang-tidy.enable = true;
      deadnix.enable = true;
      markdownlint.enable = true;
      nil.enable = true;
      nixfmt.enable = true;
      statix.enable = true;
    };

    settings.markdownlint.config = {
      MD034 = false;
      MD013.line_length = 200;
    };

    tools = pkgs;
  };
}
