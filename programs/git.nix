{ ... }: {
  # Git configuration
  programs.git = {
    enable = true;
    userName = "1Solon";
    userEmail = "Solonerus@gmail.com";
    extraConfig = {
      "protocol.https".allow = "always";
      "push".autoSetupRemote = true;
      "init".defaultBranch = "main";
    };
  };
}