{
  bind = [
    "$mod, Return, exec, kitty"
    "$mod, Space, exec, rofi -show drun"
    "$mod, N, exec, kitty -e nvim"
    "$mod, W, killactive"
    "$mod, T, togglefloating"
    "$mod, F, fullscreen"
    ", F11, fullscreen"
    "$mod, Escape, exec, wlogout -p layer-shell"
    "$mod, L, exec, lockscreen"
    "$mod SHIFT, M, exit"

    "$mod, V, exec, rofi-clipboard"
    "$mod SHIFT, V, exec, rofi-clipboard-del"
    "$mod SHIFT, N, exec, swaync-client -t -sw"

    "$mod, Tab, exec, rofi -show window"
    "$mod, C, exec, rofi -show calc -modi calc -no-show-match -no-sort"
    "$mod, period, exec, rofi -show emoji"
    "$mod, O, exec, rofi-obsidian"

    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"

    "$mod SHIFT, left, movewindow, l"
    "$mod SHIFT, right, movewindow, r"
    "$mod SHIFT, up, movewindow, u"
    "$mod SHIFT, down, movewindow, d"

    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"

    "$mod SHIFT, 1, movetoworkspace, 1"
    "$mod SHIFT, 2, movetoworkspace, 2"
    "$mod SHIFT, 3, movetoworkspace, 3"
    "$mod SHIFT, 4, movetoworkspace, 4"
    "$mod SHIFT, 5, movetoworkspace, 5"
    "$mod SHIFT, 6, movetoworkspace, 6"
    "$mod SHIFT, 7, movetoworkspace, 7"
    "$mod SHIFT, 8, movetoworkspace, 8"
    "$mod SHIFT, 9, movetoworkspace, 9"

    ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
    "SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"

    "$mod CTRL, space, exec, kitty --class walt -e walt"

    "$mod SHIFT, R, exec, toggle-retro-shader"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  binde = [
    "$mod, equal, resizeactive, 50 0"
    "$mod, minus, resizeactive, -50 0"
    "$mod SHIFT, equal, resizeactive, 0 50"
    "$mod SHIFT, minus, resizeactive, 0 -50"
  ];

  bindl = [
    ", XF86AudioMute, exec, pamixer -t"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"
  ];

  bindel = [
    ", XF86AudioRaiseVolume, exec, pamixer -i 5"
    ", XF86AudioLowerVolume, exec, pamixer -d 5"
    ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
  ];
}
