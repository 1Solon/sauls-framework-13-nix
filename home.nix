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
    # Editors
    vscode

    # Version control
    git
    gh

    # Security & secrets
    _1password-cli
    _1password-gui
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

    # System utilities
    xdg-utils
    logiops

    # Communication
    discord-ptb
  ];

  # Enable Zen Browser
  programs.zen-browser.enable = true;

  # TODO: Figure out extensions
  # Zen Preferences
  programs.zen-browser.policies = {
    AutofillAddressEnabled = true;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
  };

  # Steam configuration
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  
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