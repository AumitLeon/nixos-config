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
      key = "660BEE63A74EC2BC";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}
