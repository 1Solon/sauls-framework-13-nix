{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font.normal = {
        family = "Monaspace Neon";
        style = "Regular";
      };
    };
  };
}
