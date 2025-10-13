{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = "SUPER";
in
{
  # Enable Hyprland via Home Manager and provide a basic, sane config.
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    settings = {
      "$mod" = mod;

      # Auto-detect monitor and scale 1.0
      monitor = [ ",preferred,auto,1" ];

      # Common Wayland env vars for better app compatibility
      env = [
        "XCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_options = "caps:escape";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0; # -1.0 to 1.0, 0 means no modification
      };

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgba(89b4faee) rgba(b4befeaa) 45deg";
        "col.inactive_border" = "rgba(585b70aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
        };
        drop_shadow = true;
        shadow_range = 12;
        "col.shadow" = "rgba(00000099)";
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot,0.05,0.9,0.1,1.05"
          "smoothOut,0.36,0,0.66,-0.56"
          "smoothIn,0.25,1,0.5,1"
        ];
        animation = [
          "windows,1,7,overshot,slide"
          "border,1,10,default"
          "fade,1,7,default"
          "workspaces,1,6,overshot,slidevert"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        focus_on_activate = true;
      };

      # Keybindings: basic essentials
      bind = [
        "${mod}, Return, exec, alacritty"
        "${mod}, Q, killactive,"
        "${mod}, M, exit,"
        "${mod}, F, fullscreen, 0"
        "${mod}, V, togglefloating,"
        "${mod}, R, exec, rofi -show drun"

        # Workspaces 1..9
        "${mod}, 1, workspace, 1"
        "${mod}, 2, workspace, 2"
        "${mod}, 3, workspace, 3"
        "${mod}, 4, workspace, 4"
        "${mod}, 5, workspace, 5"
        "${mod}, 6, workspace, 6"
        "${mod}, 7, workspace, 7"
        "${mod}, 8, workspace, 8"
        "${mod}, 9, workspace, 9"

        # Move focused window to workspace 1..9
        "${mod} SHIFT, 1, movetoworkspace, 1"
        "${mod} SHIFT, 2, movetoworkspace, 2"
        "${mod} SHIFT, 3, movetoworkspace, 3"
        "${mod} SHIFT, 4, movetoworkspace, 4"
        "${mod} SHIFT, 5, movetoworkspace, 5"
        "${mod} SHIFT, 6, movetoworkspace, 6"
        "${mod} SHIFT, 7, movetoworkspace, 7"
        "${mod} SHIFT, 8, movetoworkspace, 8"
        "${mod} SHIFT, 9, movetoworkspace, 9"
      ];

      # Mouse bindings
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];
    };
  };

  # Wayland-friendly session env
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Useful companion tools (minimal set)
  home.packages = with pkgs; [
    rofi-wayland
    wl-clipboard
  ];

  # XDG config conveniences
  xdg.enable = true;
}
