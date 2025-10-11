{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "saul";
  home.homeDirectory = "/home/saul";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    ./programs/zen.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    # Editors
    vscode

    # Version control
    git
    gh

    # Security & secrets
    sops

    # Kubernetes & cluster tooling
    k9s
    kubectl
    talosctl

    # Containers
    docker
    docker-compose

    # Shell & prompt
    zsh
    zsh-autocomplete
    starship

    # Languages & toolchains
    cue
    go
    python3

    # Build & task runners
    go-task
    gnumake
    nixfmt-rfc-style

    # System utilities
    xdg-utils
    logiops

    # Communication
    discord-ptb
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
      update = "nix flake update --flake /home/saul/sauls-framework-13-nixos && sudo nixos-rebuild switch --impure --flake /home/saul/sauls-framework-13-nixos#sauls-laptop";
      config = "code /home/saul/sauls-framework-13-nixos";
      init-kube = "mkdir -p ~/.kube && op document get \"kubeconfig\" > ~/.kube/config";
      init-talos = "mkdir -p ~/.talos && op document get \"talosconfig\" > ~/.talos/config";
    };
  };

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = { };
  };
}
