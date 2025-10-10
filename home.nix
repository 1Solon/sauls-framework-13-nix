{ config, pkgs, inputs, ...}:

{ 
  home.username = "saul";
  home.homeDirectory = "/home/saul";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

   home.packages = with pkgs; [
    vscode
    git
    gh
    _1password-gui
    _1password-cli
    k9s
    kubectl
    talosctl
    sops
    zsh
    starship
    zsh-autocomplete
    xdg-utils
    docker
    docker-compose
    go-task
    gnumake
    go
    cue
    python3
  ];

  # zen
  programs.zen-browser.enable = true;
  
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
      update = "nix flake update /home/saul/sauls-framework-13-nixos && sudo nixos-rebuild switch --impure --flake /home/saul/sauls-framework-13-nixos#sauls-laptop";
      config = "code /home/saul/sauls-framework-13-nixos";
    };
  };

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = {};
  };
}