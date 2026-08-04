{ self, inputs, ... }: {
  flake.homeManagerModules.homeBase = { lib, ... }: {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
      self.homeManagerModules.fish
      self.homeManagerModules.starship
      self.homeManagerModules.tmux
      self.homeManagerModules.neovim
      self.homeManagerModules.nixAliases
      self.homeManagerModules.obs
      self.homeManagerModules.nixvim
    ];

    hm = {
      fish.enable = true;
      starship.enable = true;
      tmux.enable = true;
      neovim.enable = false;
      nixAliases.enable = true;
      obs.enable = true;
      nixvim.enable = true;
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    home.stateVersion = "25.05";
    programs.home-manager.enable = true;
  };
}
