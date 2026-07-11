{ self, inputs, ... }: {
  flake.nixosModules.kernel = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.kernel;
  in {
    options.sys.kernel = {
      variant = mkOption {
        type    = types.enum [ "zen" "cachyos" "default" ];
        default = "zen";
        description = ''
          Kernel à utiliser :
          - "zen"     : kernel Zen (nixpkgs, cache binaire garanti, performances ++)
          - "cachyos" : kernel CachyOS via xddxdd/nix-cachyos-kernel (attention : compile
                        depuis les sources si pas dans le cache — nécessite 16+ Go RAM)
          - "default" : kernel NixOS standard
        '';
      };
    };

    config = mkMerge [
      (mkIf (cfg.variant == "zen") {
        boot.kernelPackages = pkgs.linuxPackages_zen;
      })
      (mkIf (cfg.variant == "cachyos") {
        nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.default ];
        boot.kernelPackages = pkgs.linuxPackages_cachyos;
      })
    ];
  };
}
