{
  config,
  pkgs,
  flakeName,
  ...
}: let
  signingKey =
    if flakeName == "framework-desktop"
    then "85CED8113959124F"
    else if flakeName == "vm-aarch64"
    then "660BEE63A74EC2BC"
    else null;
in {
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "Aumit Leon";
        email = "aumitleon@gmail.com";
      };

      # GPG signing configuration (if signing key is available)
      signing = {
        sign-all = signingKey != null;
        backend = "gpg";
        key = signingKey;
        behavior = "own";
      };

      # Set the default editor
      ui = {
        editor = "nvim";
        default-command = "log";
      };

      # Git integration settings
      git = {
        push-branch-prefix = "aumit/";
      };

      aliases = {
        tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
      };
    };
  };
}
