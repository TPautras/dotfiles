{ self, inputs, ... }: {
  flake.homeManagerModules.homeBase = { lib, ... }: {
    imports = [
      self.homeManagerModules.fish
      self.homeManagerModules.starship
      self.homeManagerModules.tmux
      self.homeManagerModules.neovim
      self.homeManagerModules.nixAliases
      self.homeManagerModules.obs
    ];

    hm = {
      fish.enable      = true;
      starship.enable  = true;
      tmux.enable      = true;
      neovim.enable    = true;
      nixAliases.enable = true;
      obs.enable = true;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    home.stateVersion = "25.05";
    programs.home-manager.enable = true;
  };
}
