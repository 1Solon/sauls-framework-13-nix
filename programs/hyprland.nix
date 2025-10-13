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
  # Enable Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    settings = {
      "$mod" = mod;

      # Auto-detect monitor and scale
      monitor = [ ",preferred,auto,2" ];

      # Makes everything use the wayland backend where possible
      env = [
        "NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11"
        "MOZ_ENABLE_WAYLAND=1"
      ];

      # Autostart
      exec-once = [
        "waybar"
        "dunst"
        "sh -c 'mkdir -p \"$HOME\"/Pictures/screenshots'"
      ];

      input = {
        kb_layout = "gb";
        kb_variant = "";
        kb_options = "caps:escape";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      # Keybindings
      bind = [
        # Terminal
        "${mod}, Q, exec, alacritty"

        # App launcher
        "${mod}, R, exec, rofi -show drun"

        # Window controls
        "${mod}, M, exit,"
        "${mod}, F, fullscreen, 0"
        "${mod}, V, togglefloating,"

        # Workspaces 1..10 (0 maps to 10)
        "${mod}, 1, workspace, 1"
        "${mod}, 2, workspace, 2"
        "${mod}, 3, workspace, 3"
        "${mod}, 4, workspace, 4"
        "${mod}, 5, workspace, 5"
        "${mod}, 6, workspace, 6"
        "${mod}, 7, workspace, 7"
        "${mod}, 8, workspace, 8"
        "${mod}, 9, workspace, 9"
        "${mod}, 0, workspace, 10"

        # Move focused window to workspace 1..10
        "${mod} SHIFT, 1, movetoworkspace, 1"
        "${mod} SHIFT, 2, movetoworkspace, 2"
        "${mod} SHIFT, 3, movetoworkspace, 3"
        "${mod} SHIFT, 4, movetoworkspace, 4"
        "${mod} SHIFT, 5, movetoworkspace, 5"
        "${mod} SHIFT, 6, movetoworkspace, 6"
        "${mod} SHIFT, 7, movetoworkspace, 7"
        "${mod} SHIFT, 8, movetoworkspace, 8"
        "${mod} SHIFT, 9, movetoworkspace, 9"
        "${mod} SHIFT, 0, movetoworkspace, 10"

        # Screenshots
        ", Print, exec, sh -c 'REGION=$(slurp) || exit; grim -g \"$REGION\" - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify \"Screenshot of the region taken\" -t 1000'"
        "SHIFT, Print, exec, sh -c 'grim - | wl-copy && wl-paste > ~/Pictures/screenshots/Screenshot-$(date +%F_%T).png && dunstify \"Screenshot of the whole screen taken\" -t 1000'"
      ];

      # Mouse bindings
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];
    };
  };

  # Waybar with Hyprland workspaces
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "pulseaudio" "network" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{name}"; # show numeric workspace names
        };

        clock = {
          format = "{:%a %b %d  %I:%M %p}";
          tooltip = true;
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };

        pulseaudio = {
          format = "{volume}% ";
          format-muted = "Muted ";
          scroll-step = 5;
        };

        network = {
          format-wifi = "{signalStrength}% ";
          format-ethernet = "";
          format-disconnected = "";
          tooltip = true;
        };

        battery = {
          states = { warning = 25; critical = 10; };
          format = "{capacity}% {icon}";
          "format-icons" = [ "" "" "" "" "" ];
        };

        tray = { spacing = 8; };

        cpu = { format = " {usage}%"; tooltip = false; };
        memory = { format = " {percentage}%"; tooltip = false; };
      };
    };
  };

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    dunst
    libnotify
    rofi-wayland
  ];

  # XDG config conveniences
  xdg.enable = true;
}
