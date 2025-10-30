{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    signing = {
      key = "85CED8113959124F";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Aumit Leon";
        email = "aumitleon@gmail.com";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}
