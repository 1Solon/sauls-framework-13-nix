{ config, pkgs, ... }:
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

      # Window chrome
      general = {
        border_size = 0; # no border
        "col.active_border" = "rgba(c0c0c0ff)"; # silver
        "col.inactive_border" = "rgba(3a3d42cc)"; # muted border
      };

      # Decoration settings
      decoration = {
        rounding = 10;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "0xaa000000";
        };
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
        };
        dim_inactive = true;
        dim_strength = 0.05;
      };

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
        "sh -c 'mkdir -p \"$HOME\"/Pictures/screenshots'"
        "sh -c 'mkdir -p \"$HOME\"/Pictures/Wallpapers'"
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

      # Touchpad gestures
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 500;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_create_new = true;
      };

      # Keybindings
      bind = [
        # Terminal
        "${mod}, Q, exec, alacritty"

        # App launcher
        "${mod}, R, exec, rofi -show drun -theme ~/.config/rofi/themes/silver-gray.rasi"

        # Window controls
        "${mod}, M, exit,"
        "${mod}, C, killactive,"
        "${mod}, F, fullscreen, 0"
        "${mod}, V, togglefloating,"

        # Alt+Tab window switching with rofi
        "ALT, Tab, exec, rofi -show window -theme ~/.config/rofi/themes/silver-gray.rasi"

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

        # Volume controls
        ''${mod}, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && dunstify "Volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')%" -t 1000''
        ''${mod}, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && dunstify "Volume: $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')%" -t 1000''
        ''${mod}, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && dunstify "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo 'Muted' || echo 'Unmuted')" -t 1000''

        # Brightness controls
        ''${mod}, XF86MonBrightnessUp, exec, brightnessctl set 5%+ && dunstify "Brightness: $(brightnessctl -m info | cut -d, -f4)" -t 1000''
        ''${mod}, XF86MonBrightnessDown, exec, brightnessctl set 5%- && dunstify "Brightness: $(brightnessctl -m info | cut -d, -f4)" -t 1000''
      ];

      # Mouse bindings
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];

      # Subtle blur for Waybar
      layerrule = [ "blur, waybar" ];
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
        height = 40;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "pulseaudio"
          "network"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{name}"; # show numeric workspace names
        };

        clock = {
          format = "{:%a %b %d  %H:%M}";
          tooltip = true;
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };

        pulseaudio = {
          format = "{volume}% ";
          format-muted = "Muted ";
          scroll-step = 5;
        };

        network = {
          format-wifi = "{signalStrength}% ";
          format-ethernet = "";
          format-disconnected = "";
          tooltip = true;
          on-click = "alacritty -e nmtui";
        };

        battery = {
          states = {
            warning = 25;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        tray = {
          spacing = 8;
        };

        cpu = {
          format = " {usage}%";
          tooltip = false;
          on-click = "alacritty -e btop --preset 1";
        };
        memory = {
          format = " {percentage}%";
          tooltip = false;
          on-click = "alacritty -e btop --preset 2";
        };
      };
    };
    # Waybar styling
    style = ''
      @define-color base #1f2124;
      @define-color surface #2a2c30;
      @define-color text #e6e6e6;
      @define-color muted #9aa0a6;
      @define-color accent #c0c0c0;
      @define-color border #3a3d42;

      window#waybar {
        background: alpha(@base, 0.85);
        color: @text;
        border: 1px solid @border;
        border-radius: 10px;
      }

      tooltip {
        background: @surface;
        color: @text;
        border: 1px solid @border;
      }

      #workspaces button {
        padding: 0 10px;
        color: @muted;
        background: transparent;
        border: 1px solid transparent;
        border-radius: 8px;
      }
      #workspaces button.active {
        color: @text;
        background: @surface;
        border: 1px solid @accent;
      }
      #workspaces button:hover {
        background: alpha(@surface, 0.6);
        color: @text;
      }

      #clock, #cpu, #memory, #network, #pulseaudio, #battery, #tray {
        background: transparent;
        color: @text;
        padding: 0 12px;
        margin: 0 2px;
      }

      #battery.warning { color: #ffcc66; }
      #battery.critical { color: #ff6666; }
    '';
  };

  # Hyprpaper for wallpapers
  services.hyprpaper.enable = true;

  services.hyprpaper.settings =
    let
      wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";
    in
    {
      ipc = false;
      splash = false;

      preload = [
        "${wallpaperDir}/progress.jpg"
      ];

      wallpaper = [
        ",${wallpaperDir}/progress.jpg"
      ];
    };

  # Dunst as a managed service theme
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#c0c0c0";
        separator_color = "frame";
        corner_radius = 8;
        padding = 8;
        horizontal_padding = 10;
        origin = "top-right";
        offset = "12x12";
        font = "Sans 10";
        markup = true;
        transparency = 10;
      };
      urgency_low = {
        background = "#2a2c30";
        foreground = "#e6e6e6";
        frame_color = "#3a3d42";
        timeout = 4;
      };
      urgency_normal = {
        background = "#2a2c30";
        foreground = "#e6e6e6";
        frame_color = "#c0c0c0";
        timeout = 6;
      };
      urgency_critical = {
        background = "#2a2c30";
        foreground = "#ffffff";
        frame_color = "#ff6666";
        timeout = 0;
      };
    };
  };

  # XDG config conveniences
  xdg.enable = true;

  # Rofi theme
  xdg.configFile."rofi/themes/silver-gray.rasi".text = ''
    * {
      bg:      #121417;
      bg-alt:  #1b1d21;
      fg:      #e6e6e6;
      muted:   #9aa0a6;
      accent:  #b8b9bd;
      border:  #2b2e33;
    }

    window {
      background-color: @bg;
      border: 1;
      border-color: @border;
      border-radius: 10;
    }

    mainbox {
      background-color: @bg;
      padding: 10;
      spacing: 8;
    }

    inputbar {
      background-color: @bg-alt;
      text-color: @fg;
      border: 1;
      border-color: @border;
    }

    listview { background-color: @bg; spacing: 2; }
    textbox { background-color: @bg; text-color: @fg; }
    prompt { background-color: @bg-alt; text-color: @fg; }
    entry { background-color: @bg-alt; text-color: @fg; }

    element { background-color: @bg; text-color: @fg; border: 0; }
    element alternate { background-color: @bg; }
    element normal { background-color: @bg; }
    element selected {
      background-color: @bg-alt;
      text-color: @fg;
      border: 1;
      border-color: @accent;
      border-radius: 6;
    }
    element-text { background-color: inherit; text-color: inherit; highlight: @accent; }
    element-icon { background-color: inherit; }

    prompt, message { text-color: @fg; }
  '';

  # Cursor to match the theme (grey/silver)
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 12;
    gtk.enable = true;
  };
}
