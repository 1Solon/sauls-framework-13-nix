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
      ];

      input = {
        kb_layout = "gb";
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
        # Terminal
        "${mod}, Q, exec, alacritty"
        "${mod}, Return, exec, alacritty"

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

    style = ''
      * {
        font-family: "Monaspace Neon", "Fira Sans", sans-serif;
        font-size: 12pt;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
        border-bottom: 1px solid rgba(108, 112, 134, 0.35);
      }
      #workspaces button {
        padding: 0 8px;
        color: #a6adc8;
      }
      #workspaces button.active {
        color: #11111b;
        background: #89b4fa;
        border-radius: 8px;
      }
      #cpu, #memory, #battery, #network, #pulseaudio, #clock, #tray {
        padding: 0 10px;
      }
      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
    '';
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

  # XDG config conveniences
  xdg.enable = true;
}
