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
    ./programs/git.nix
    ./programs/github-cli.nix
    ./programs/zsh.nix
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

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = { };
  };
}
