sudo nixos-rebuild switch --flake .#jade --show-trace --print-build-logs --verbose
$ nix --extra-experimental-features nix-command flakes build --out-link /tmp/nixos-rebuild.n4ui7L/nixos-rebuild .#nixosConfigurations."jade".config.system.build.nixos-rebuild --sh
ow-trace --print-build-logs --verbose                                                                                                                                              $ exec /nix/store/r6x37z9h1aifnpj406a2a31wwxhvamd4-nixos-rebuild/bin/nixos-rebuild switch --flake .#jade --show-trace --print-build-logs --verbose
building the system configuration...
Building in flake mode.
$ nix --extra-experimental-features nix-command flakes build .#nixosConfigurations."jade".config.system.build.toplevel --show-trace --print-build-logs --verbose --out-link /tmp/ni
xos-rebuild.DbtFCz/result                                                                                                                                                          error:
       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1537:24:

         1536|     let f = attrPath:
         1537|       zipAttrsWith (n: values:
             |                        ^
         1538|         let here = attrPath ++ [n]; in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1171:18:

         1170|         mapAttrs
         1171|           (name: value:
             |                  ^
         1172|             if isAttrs value && cond value

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1174:18:

         1173|             then recurse (path ++ [ name ]) value
         1174|             else f (path ++ [ name ]) value);
             |                  ^
         1175|     in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `system.build.toplevel':

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                  
       … while evaluating definitions from `/nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/nixos/modules/system/activation/top-level.nix':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                               |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/nixos/modules/system/activation/top-level.nix:71:12:

           70|   # Replace runtime dependencies
           71|   system = foldr ({ oldDependency, newDependency }: drv:
             |            ^
           72|       pkgs.replaceDependency { inherit oldDependency newDependency drv; }

       … while calling 'foldr'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:121:20:

          120|   */
          121|   foldr = op: nul: list:
             |                    ^
          122|     let

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:128:8:

          127|         else op (elemAt list n) (fold' (n + 1));
          128|     in fold' 0;
             |        ^
          129|

       … while calling 'fold''

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:124:15:

          123|       len = length list;
          124|       fold' = n:
             |               ^
          125|         if n == len

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/nixos/modules/system/activation/top-level.nix:68:10:

           67|     then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
           68|     else showWarnings config.warnings baseSystem;
             |          ^
           69|

       … while calling 'showWarnings'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/trivial.nix:849:28:

          848|
          849|   showWarnings = warnings: res: lib.foldr (w: x: warn w x) res warnings;
             |                            ^
          850|

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/trivial.nix:849:33:

          848|
          849|   showWarnings = warnings: res: lib.foldr (w: x: warn w x) res warnings;
             |                                 ^
          850|

       … while calling 'foldr'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:121:20:

          120|   */
          121|   foldr = op: nul: list:
             |                    ^
          122|     let

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:128:8:

          127|         else op (elemAt list n) (fold' (n + 1));
          128|     in fold' 0;
             |        ^
          129|

       … while calling 'fold''

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:124:15:

          123|       len = length list;
          124|       fold' = n:
             |               ^
          125|         if n == len

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1171:18:

         1170|         mapAttrs
         1171|           (name: value:
             |                  ^
         1172|             if isAttrs value && cond value

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1174:18:

         1173|             then recurse (path ++ [ name ]) value
         1174|             else f (path ++ [ name ]) value);
             |                  ^
         1175|     in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `warnings':

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                  
       … while evaluating definitions from `/nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/nixos/modules/system/boot/systemd.nix':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                               |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1062:10:

         1061|     attrs:
         1062|     map (name: f name attrs.${name}) (attrNames attrs);
             |          ^
         1063|

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1062:16:

         1061|     attrs:
         1062|     map (name: f name attrs.${name}) (attrNames attrs);
             |                ^
         1063|

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/nixos/modules/system/boot/systemd.nix:440:16:

          439|       mapAttrsToList
          440|         (name: service:
             |                ^
          441|           let

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/nixos/modules/system/boot/systemd.nix:447:16:

          446|             concatLists [
          447|               (optional (type == "oneshot" && (restart == "always" || restart == "on-success"))
             |                ^
          448|                 "Service '${name}.service' with 'Type=oneshot' cannot have 'Restart=always' or 'Restart=on-success'"

       … while calling 'optional'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:736:20:

          735|   */
          736|   optional = cond: elem: if cond then [elem] else [];
             |                    ^
          737|

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1171:18:

         1170|         mapAttrs
         1171|           (name: value:
             |                  ^
         1172|             if isAttrs value && cond value

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1174:18:

         1173|             then recurse (path ++ [ name ]) value
         1174|             else f (path ++ [ name ]) value);
             |                  ^
         1175|     in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `systemd.services.home-manager-thomas.serviceConfig':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:846:59:

          845|       if isDefined then
          846|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal
             |                                                           ^
          847|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;

       … while calling 'merge'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:568:20:

          567|       check = isAttrs;
          568|       merge = loc: defs:
             |                    ^
          569|         mapAttrs (n: v: v.value) (filterAttrs (n: v: v ? value) (zipAttrsWith (name: defs:

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:569:35:

          568|       merge = loc: defs:
          569|         mapAttrs (n: v: v.value) (filterAttrs (n: v: v ? value) (zipAttrsWith (name: defs:
             |                                   ^
          570|             (mergeDefinitions (loc ++ [name]) elemType defs).optionalValue

       … while calling 'filterAttrs'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:646:5:

          645|     pred:
          646|     set:
             |     ^
          647|     listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:647:29:

          646|     set:
          647|     listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));
             |                             ^
          648|

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:647:62:

          646|     set:
          647|     listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));
             |                                                              ^
          648|

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:569:51:

          568|       merge = loc: defs:
          569|         mapAttrs (n: v: v.value) (filterAttrs (n: v: v ? value) (zipAttrsWith (name: defs:
             |                                                   ^
          570|             (mergeDefinitions (loc ++ [name]) elemType defs).optionalValue

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:569:86:

          568|       merge = loc: defs:
          569|         mapAttrs (n: v: v.value) (filterAttrs (n: v: v ? value) (zipAttrsWith (name: defs:
             |                                                                                      ^
          570|             (mergeDefinitions (loc ++ [name]) elemType defs).optionalValue

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                  
       … while evaluating definitions from `/nix/store/0zzcahfwhrnb7kzgkragzawhici6q3qn-source/hosts/common':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                               |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … while evaluating derivation 'home-manager-generation'
         whose name attribute is located at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/pkgs/stdenv/generic/make-derivation.nix:331:7

       … while evaluating attribute 'buildCommand' of derivation 'home-manager-generation'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/pkgs/build-support/trivial-builders/default.nix:68:16:

           67|         enableParallelBuilding = true;
           68|         inherit buildCommand name;
             |                ^
           69|         passAsFile = [ "buildCommand" ]

       … while evaluating derivation 'activation-script'
         whose name attribute is located at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/pkgs/stdenv/generic/make-derivation.nix:331:7

       … while evaluating attribute 'text' of derivation 'activation-script'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/pkgs/build-support/trivial-builders/default.nix:103:16:

          102|       ({
          103|         inherit text executable checkPhase allowSubstitutes preferLocalBuild;
             |                ^
          104|         passAsFile = [ "text" ]

       … while calling 'mkCmd'

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/home-environment.nix:666:17:

          665|       let
          666|         mkCmd = res: ''
             |                 ^
          667|             _iNote "Activating %s" "${res.name}"

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1171:18:

         1170|         mapAttrs
         1171|           (name: value:
             |                  ^
         1172|             if isAttrs value && cond value

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1174:18:

         1173|             then recurse (path ++ [ name ]) value
         1174|             else f (path ++ [ name ]) value);
             |                  ^
         1175|     in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `home-manager.users.thomas.home.activation.checkFilesChanged.data':

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                  
       … while evaluating definitions from `/nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/files.nix':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                               |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … from call site

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/files.nix:301:12:

          300|         declare -A changedFiles
          301|       '' + concatMapStrings (v:
             |            ^
          302|         let

       … while calling 'concatMapStrings'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/strings.nix:60:25:

           59|   */
           60|   concatMapStrings = f: list: concatStrings (map f list);
             |                         ^
           61|

       … while calling anonymous lambda

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/files.nix:301:30:

          300|         declare -A changedFiles
          301|       '' + concatMapStrings (v:
             |                              ^
          302|         let

       … from call site

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/files.nix:303:23:

          302|         let
          303|           sourceArg = escapeShellArg (sourceStorePath v);
             |                       ^
          304|           targetArg = escapeShellArg v.target;

       … while calling 'escapeShellArg'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/strings.nix:442:20:

          441|   */
          442|   escapeShellArg = arg: "'${replaceStrings ["'"] ["'\\''"] (toString arg)}'";
             |                    ^
          443|

       … from call site

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/files.nix:303:39:

          302|         let
          303|           sourceArg = escapeShellArg (sourceStorePath v);
             |                                       ^
          304|           targetArg = escapeShellArg v.target;

       … while calling 'sourceStorePath'

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/files.nix:15:21:

           14|
           15|   sourceStorePath = file:
             |                     ^
           16|     let

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1171:18:

         1170|         mapAttrs
         1171|           (name: value:
             |                  ^
         1172|             if isAttrs value && cond value

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1174:18:

         1173|             then recurse (path ++ [ name ]) value
         1174|             else f (path ++ [ name ]) value);
             |                  ^
         1175|     in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `home-manager.users.thomas.home.file."/home/thomas/.config/waybar/config".source':

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                  
       … while evaluating definitions from `/nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/misc/xdg.nix':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                               |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1171:18:

         1170|         mapAttrs
         1171|           (name: value:
             |                  ^
         1172|             if isAttrs value && cond value

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1174:18:

         1173|             then recurse (path ++ [ name ]) value
         1174|             else f (path ++ [ name ]) value);
             |                  ^
         1175|     in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `home-manager.users.thomas.xdg.configFile."waybar/config".source':

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:846:17:

          845|       if isDefined then
          846|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal
             |                 ^
          847|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:846:22:

          845|       if isDefined then
          846|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal
             |                      ^
          847|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;

       … while calling 'check'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:520:15:

          519|       descriptionClass = "noun";
          520|       check = x: isStringLike x && builtins.substring 0 1 (toString x) == "/";
             |               ^
          521|       merge = mergeEqualOption;

       … while evaluating derivation 'waybar-config.json'
         whose name attribute is located at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/pkgs/stdenv/generic/make-derivation.nix:331:7

       … while evaluating attribute 'value' of derivation 'waybar-config.json'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/pkgs/pkgs-lib/formats.nix:64:7:

           63|       nativeBuildInputs = [ jq ];
           64|       value = builtins.toJSON value;
             |       ^
           65|       passAsFile = [ "value" ];

       … while calling 'makeConfiguration'

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/programs/waybar.nix:247:25:

          246|     # (strips our custom settings before converting to JSON)
          247|     makeConfiguration = configuration:
             |                         ^
          248|       let

       … from call site

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/programs/waybar.nix:254:10:

          253|           optionalAttrs (configuration.modules != null) configuration.modules;
          254|       in removeTopLevelNulls (settingsWithoutModules // settingsModules);
             |          ^
          255|

       … while calling 'filterAttrs'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:646:5:

          645|     pred:
          646|     set:
             |     ^
          647|     listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:647:29:

          646|     set:
          647|     listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));
             |                             ^
          648|

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:647:62:

          646|     set:
          647|     listToAttrs (concatMap (name: let v = set.${name}; in if pred name v then [(nameValuePair name v)] else []) (attrNames set));
             |                                                              ^
          648|

       … while calling anonymous lambda

         at /nix/store/8snr5588d68q91dvgsyh82vxd3qcgg4a-source/modules/programs/waybar.nix:243:43:

          242|     # This is not recursive.
          243|     removeTopLevelNulls = filterAttrs (_: v: v != null);
             |                                           ^
          244|

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1537:24:

         1536|     let f = attrPath:
         1537|       zipAttrsWith (n: values:
             |                        ^
         1538|         let here = attrPath ++ [n]; in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1171:18:

         1170|         mapAttrs
         1171|           (name: value:
             |                  ^
         1172|             if isAttrs value && cond value

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/attrsets.nix:1174:18:

         1173|             then recurse (path ++ [ name ]) value
         1174|             else f (path ++ [ name ]) value);
             |                  ^
         1175|     in

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:242:72:

          241|           # For definitions that have an associated option
          242|           declaredConfig = mapAttrsRecursiveCond (v: ! isOption v) (_: v: v.value) options;
             |                                                                        ^
          243|

       … while evaluating the option `home-manager.users.thomas.programs.waybar.settings.mainBar.modules-right':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:846:59:

          845|       if isDefined then
          846|         if all (def: type.check def.value) defsFinal then type.merge loc defsFinal
             |                                                           ^
          847|         else let allInvalid = filter (def: ! type.check def.value) defsFinal;

       … while calling 'merge'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:537:20:

          536|       check = isList;
          537|       merge = loc: defs:
             |                    ^
          538|         map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:538:35:

          537|       merge = loc: defs:
          538|         map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:
             |                                   ^
          539|           imap1 (m: def':

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:334:29:

          333|   */
          334|   imap1 = f: list: genList (n: f (n + 1) (elemAt list n)) (length list);
             |                             ^
          335|

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/lists.nix:334:32:

          333|   */
          334|   imap1 = f: list: genList (n: f (n + 1) (elemAt list n)) (length list);
             |                                ^
          335|

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/types.nix:539:21:

          538|         map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:
          539|           imap1 (m: def':
             |                     ^
          540|             (mergeDefinitions

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:824:28:

          823|         # Process mkMerge and mkIf properties.
          824|         defs' = concatMap (m:
             |                            ^
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                  
       … while evaluating definitions from `/nix/store/0zzcahfwhrnb7kzgkragzawhici6q3qn-source/home/features/desktop/waybar/settings.nix':

       … from call site

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:825:137:

          824|         defs' = concatMap (m:
          825|           map (value: { inherit (m) file; inherit value; }) (builtins.addErrorContext "while evaluating definitions from `${m.file}':" (dischargeProperties m.value)
)                                                                                                                                                                                               |                                                                                                                                         ^
          826|         ) defs;

       … while calling 'dischargeProperties'

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:896:25:

          895|   */
          896|   dischargeProperties = def:
             |                         ^
          897|     if def._type or "" == "merge" then

       … while calling anonymous lambda

         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:506:44:

          505|       context = name: ''while evaluating the module argument `${name}' in "${key}":'';
          506|       extraArgs = builtins.mapAttrs (name: _:
             |                                            ^
          507|         builtins.addErrorContext (context name)

       … while evaluating the module argument `host' in "/nix/store/0zzcahfwhrnb7kzgkragzawhici6q3qn-source/home/features/desktop/waybar/settings.nix":

       error: attribute 'host' missing

       at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:508:28:

          507|         builtins.addErrorContext (context name)
          508|           (args.${name} or config._module.args.${name})
             |                            ^
          509|       ) (lib.functionArgs f);
