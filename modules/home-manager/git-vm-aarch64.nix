{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    signing = {
      key = "660BEE63A74EC2BC";
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
