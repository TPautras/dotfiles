{ ef, hex }:
{
  general = {
    gaps_in               = 8;
    gaps_out              = 8;
    border_size           = 2;
    "col.active_border"   = "rgb(${hex ef.green})";
    "col.inactive_border" = "rgb(${hex ef.bg2})";
    layout                = "dwindle";
  };

  decoration = {
    rounding         = 8;
    active_opacity   = 1.0;
    inactive_opacity = 0.9;
    blur = {
      enabled = true;
      size    = 5;
      passes  = 2;
    };
    shadow = {
      enabled      = true;
      range        = 12;
      render_power = 3;
    };
  };

  animations = {
    enabled = true;
    bezier  = "ease, 0.25, 0.1, 0.25, 1.0";
    animation = [
      "windows, 1, 4, ease"
      "fade, 1, 4, ease"
      "workspaces, 1, 4, ease, slide"
    ];
  };

  dwindle = {
    preserve_split = true;
  };

  misc = {
    force_default_wallpaper  = 0;
    disable_hyprland_logo    = true;
    disable_splash_rendering = true;
  };
}
