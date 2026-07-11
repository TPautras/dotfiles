{ lib, ... }: {
  options.flake.homeManagerModules = lib.mkOption {
    type        = lib.types.lazyAttrsOf lib.types.unspecified;
    default     = {};
    description = "Home Manager modules exposed by this flake.";
  };
}
