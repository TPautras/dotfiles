{ self, inputs, ... }: {
  flake.nixosModules.profileBase = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.boot
      self.nixosModules.greetd
      self.nixosModules.networking
      self.nixosModules.locale
      self.nixosModules.programs
      inputs.home-manager.nixosModules.home-manager
    ];

    sys = {
      boot.enable       = true;
      networking.enable = true;
      locale = {
        enable   = true;
        timezone = lib.mkDefault "Europe/Paris";
      };
      programs.enable   = true;
      greetd.enable     = true;
    };

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users         = [ "root" "thomas" ];
        auto-optimise-store   = true;
        warn-dirty            = false;

        # Binary caches. extra-* appends to cache.nixos.org instead of replacing it.
        # hyprland.cachix serves the flake's Hyprland so it isn't built from source.
        extra-substituters        = [ "https://hyprland.cachix.org" ];
        extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
      gc = {
        automatic = true;
        dates     = "weekly";
        options   = "--delete-older-than 30d";
      };
      registry = lib.mapAttrs (_: flake: { inherit flake; }) (
        lib.filterAttrs (_: lib.isType "flake") inputs
      );
      nixPath = [ "/etc/nix/path" ];
    };

    nixpkgs.config.allowUnfree = true;

    services.openssh = {
      enable                          = true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin        = "no";
    };

    home-manager = {
      useUserPackages     = true;
      useGlobalPkgs       = true;
      backupFileExtension = "backup";
      extraSpecialArgs    = {
        inherit inputs;
        outputs = inputs.self;
      };
    };

    users.defaultUserShell = pkgs.fish;
  };
}
