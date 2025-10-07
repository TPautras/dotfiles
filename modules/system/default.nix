{ lib, ... }:

let
  inherit (lib) mapAttrs mapAttrsRecursive collect isString concatStringsSep
                 hasSuffix hasPrefix sort lessThan filter pipe;

  getDir = dir:
    mapAttrs (file: type:
      if type == "directory" then getDir "${dir}/${file}" else type
    ) (builtins.readDir dir);

  # build list of relative paths like "printing/default.nix"
  files = dir:
    collect isString (mapAttrsRecursive
      (path: _type: concatStringsSep "/" path)
      (getDir dir));

  importAll = dir:
    let
      rels =
        filter (file:
          hasSuffix ".nix" file
          && file != "default.nix"          # exclude THIS file
          && ! hasPrefix "x/taffybar/" file # keep your ignore
          && ! hasSuffix "-hm.nix" file
        ) (files dir);
      relsSorted = sort lessThan rels;
    in
      map (file: ./. + "/${file}") relsSorted;
in
{
  imports = importAll ./.;
}
