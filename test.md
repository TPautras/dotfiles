sudo nixos-rebuild switch --flake .#jade --show-trace --print-build-logs --verbose --option eval-cache false
[sudo] password for thomas: 
debug: nixos_rebuild.process: calling run with args=['nix', '--extra-experimental-features', 'nix-command flakes', 'build', '--print-out-paths', '.#nixosC
onfigurations."jade".config.system.build.nixos-rebuild', '-v', '--option', 'eval-cache', 'false', '--print-build-logs', '--show-trace', '--no-link'], kwargs={'stdout': -1}, extra_env=None                                                                                                                         error:
       … while calling the 'seq' builtin
         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:322:18:
          321|         options = checked options;
          322|         config = checked (removeAttrs config [ "_module" ]);
             |                  ^
          323|         _module = checked (config._module);

       … while calling the 'throw' builtin
         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:298:18:
          297|                     ''
          298|             else throw baseMsg
             |                  ^
          299|         else null;

       error: The option `hardware.graphics' does not exist. Definition values:
       - In `/nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/flake.nix':
           {
             _type = "if";
             condition = false;
             content = {
               enable = {
           ...
warning: could not build a newer version of nixos-rebuild, using current version
building the system configuration...
debug: nixos_rebuild.process: calling run with args=['nix', '--extra-experimental-features', 'nix-command flakes', 'build', '--print-out-paths', '.#nixosC
onfigurations."jade".config.system.build.toplevel', '-v', '--option', 'eval-cache', 'false', '--print-build-logs', '--show-trace', '--no-link'], kwargs={'stdout': -1}, extra_env=None                                                                                                                              error:
       … while calling the 'seq' builtin
         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:322:18:
          321|         options = checked options;
          322|         config = checked (removeAttrs config [ "_module" ]);
             |                  ^
          323|         _module = checked (config._module);

       … while calling the 'throw' builtin
         at /nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/lib/modules.nix:298:18:
          297|                     ''
          298|             else throw baseMsg
             |                  ^
          299|         else null;

       error: The option `hardware.graphics' does not exist. Definition values:
       - In `/nix/store/cb1gs888vfqxawvc65q1dk6jzbayh3wz-source/flake.nix':
           {
             _type = "if";
             condition = false;
             content = {
               enable = {
           ...
Traceback (most recent call last):
  File "/nix/store/ifyzcx9mr7ac873jdr1493vhqnfavd7a-nixos-rebuild-ng-0.0.0/lib/python3.13/site-packages/nixos_rebuild/__init__.py", line 364, in main
    execute(sys.argv)
    ~~~~~~~^^^^^^^^^^
  File "/nix/store/ifyzcx9mr7ac873jdr1493vhqnfavd7a-nixos-rebuild-ng-0.0.0/lib/python3.13/site-packages/nixos_rebuild/__init__.py", line 322, in execute
    services.build_and_activate_system(
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
        action=action,
        ^^^^^^^^^^^^^^
    ...<10 lines>...
        flake_common_flags=flake_common_flags,
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    )
    ^
  File "/nix/store/ifyzcx9mr7ac873jdr1493vhqnfavd7a-nixos-rebuild-ng-0.0.0/lib/python3.13/site-packages/nixos_rebuild/services.py", line 306, in build_and
_activate_system                                                                                                                                              path_to_config = _build_system(
        attr=attr,
    ...<9 lines>...
        flake_common_flags=flake_common_flags,
    )
  File "/nix/store/ifyzcx9mr7ac873jdr1493vhqnfavd7a-nixos-rebuild-ng-0.0.0/lib/python3.13/site-packages/nixos_rebuild/services.py", line 173, in _build_sy
stem                                                                                                                                                          path_to_config = nix.build_flake(
        attr,
    ...<2 lines>...
        | {"no_link": no_link, "dry_run": dry_run},
    )
  File "/nix/store/ifyzcx9mr7ac873jdr1493vhqnfavd7a-nixos-rebuild-ng-0.0.0/lib/python3.13/site-packages/nixos_rebuild/nix.py", line 87, in build_flake
    r = run_wrapper(run_args, stdout=PIPE)
  File "/nix/store/ifyzcx9mr7ac873jdr1493vhqnfavd7a-nixos-rebuild-ng-0.0.0/lib/python3.13/site-packages/nixos_rebuild/process.py", line 137, in run_wrappe
r                                                                                                                                                             r = subprocess.run(
        run_args,
    ...<7 lines>...
        **kwargs,
    )
  File "/nix/store/829wb290i87wngxlh404klwxql5v18p4-python3-3.13.7/lib/python3.13/subprocess.py", line 577, in run
    raise CalledProcessError(retcode, process.args,
                             output=stdout, stderr=stderr)
subprocess.CalledProcessError: Command '['nix', '--extra-experimental-features', 'nix-command flakes', 'build', '--print-out-paths', '.#nixosConfiguration
s."jade".config.system.build.toplevel', '-v', '--option', 'eval-cache', 'false', '--print-build-logs', '--show-trace', '--no-link']' returned non-zero exit status 1.                                                                                                                                               