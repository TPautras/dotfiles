{ self, inputs, ... }: {
  flake.homeManagerModules.homeDesktop = { config, ... }: {
    imports = [
      self.homeManagerModules.fonts
      self.homeManagerModules.hyprland
      self.homeManagerModules.hyprlandPlugins
      self.homeManagerModules.waybar
      self.homeManagerModules.rofi
      self.homeManagerModules.swaync
      self.homeManagerModules.wlogout
      self.homeManagerModules.hyprlock
      self.homeManagerModules.hypridle
      self.homeManagerModules.wallpaper
      self.homeManagerModules.kitty
      self.homeManagerModules.cursor
      self.homeManagerModules.obsidian
      self.homeManagerModules.aiTools
      self.homeManagerModules.fetch
    ];

    hm = {
      fetch.enable = true;
      fonts.enable    = true;
      hyprland.enable = true;
      hyprlandPlugins.enable = true;
      waybar.enable   = true;
      rofi.enable     = true;
      swaync.enable   = true;
      wlogout.enable  = true;
      hyprlock.enable = true;
      hypridle.enable = true;
      wallpaper.enable = true;
      kitty.enable    = true;
      cursor.enable   = true;
      obsidian.enable = true;
      aiTools.enable  = true;
    };

    stylix.enableReleaseChecks = false;

    gtk.gtk4.theme = config.gtk.theme;

    stylix.targets = {
      neovim.enable   = false;
      neovide.enable  = false;
      tmux.enable     = false;
      starship.enable = false;
      rofi.enable     = false;
      hyprland.enable  = false;
      hyprlock.enable  = false;
      hyprpaper.enable = false;
      swaync.enable    = false;
      waybar.enable    = false;
    };
  };
}
