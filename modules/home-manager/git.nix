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
  programs.git = {
    enable = true;

    signing = {
      key = signingKey;
      signByDefault = signingKey != null;
    };

    settings = {
      user = {
        name = "Aumit Leon";
        email = "aumitleon@gmail.com";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";

      aliases = {
        root = "rev-parse --show-toplevel";
      };
    };
  };
}
