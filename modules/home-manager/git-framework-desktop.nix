{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Aumit Leon";
    userEmail = "aumitleon@gmail.com";

    signing = {
      key = "85CED8113959124F";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}
