{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "Gruvbox Dark Hard";
    };
  };
}
