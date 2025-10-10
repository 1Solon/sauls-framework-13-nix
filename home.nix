{ pkgs, ...}:

{ 
  home.username = "saul";
  home.homeDirectory = "/home/saul";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

   home.packages = [
    pkgs.vscode
    pkgs.git
    pkgs.gh
    pkgs._1password
    pkgs._1password-gui
    pkgs._1password-cli
    pkgs.k9s
    pkgs.kubectl
    pkgs.talosctl
    pkgs.sops
    pkgs.zsh
    pkgs.starship
    pkgs.zsh-autocomplete
    pkgs.xdg-utils
    pkgs.docker
    pkgs.docker-compose
    pkgs.go-task
    pkgs.gnumake
    pkgs.go
    pkgs.cue
    pkgs.python3
  ];

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

  # Add GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch --impure --flake /home/saul/sauls-framework-13-nixos#saul";
      config = "code /home/saul/sauls-framework-13-nixos";
    };
  };

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = {};
  };
}