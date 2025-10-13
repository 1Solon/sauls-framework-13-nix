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
    # Subfile imports
    ./programs/zen.nix
    ./programs/git.nix
    ./programs/github-cli.nix
    ./programs/zsh.nix
    ./programs/starship.nix

    # External imports
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
    wezterm

    # Languages & toolchains
    cue
    go
    python3
    nodejs

    # Build & task runners
    go-task
    gnumake
    nixfmt-rfc-style

    # System utilities
    xdg-utils
    logiops

    # Communication
    discord-ptb
    thunderbird
    teams-for-linux
  ];
}
