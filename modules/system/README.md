# System-level Nix Modules
Separate Nix files can be imported as modules using an import block:
```nix
imports = [ import1.nix
            import2.nix
            ...
          ];
```
Modules in this directory are used are system-level (root) configurations.

## Host configuration toggles

The host-level configuration files (hosts/*/home.nix and the TEMPLATE) expose a small set of boolean and simple options that you can toggle per-host. Put these under `userSettings` in a host `home.nix` to enable/disable features for that machine.

Most commonly used options

- shell.enable: boolean — enable the user's shell setup
- shell.apps.enable: boolean — enable shell-provided apps
- shell.extraApps.enable: boolean — enable extra shell apps
- xdg.enable: boolean — enable XDG user directories / integration

Programs (string or booleans)

- browser: string — preferred browser (e.g. "brave")
- editor: string — preferred editor (e.g. "emacs")
- vscodium.enable: boolean — enable VSCodium
- yazi.enable: boolean — enable the Yazi reader
- git.enable: boolean — enable git-related helpers
- engineering.enable: boolean — enable engineering toolset
- art.enable: boolean — enable art/creative apps
- flatpak.enable: boolean — enable Flatpak support
- godot.enable: boolean — enable Godot engine
- keepass.enable: boolean — enable KeePass
- media.enable: boolean — enable media apps (video, codecs)
- music.enable: boolean — enable music apps
- office.enable: boolean — enable office apps
- recording.enable: boolean — enable screen/audio recording tools
- virtualization.virtualMachines.enable: boolean — enable virtual machines
- ai.enable: boolean — enable AI-related tools

Window manager / UI

- hyprland.enable: boolean — enable Hyprland session
- stylix.enable: boolean — enable the Stylix theming/styling layer

Hardware

- bluetooth.enable: boolean — enable Bluetooth support

How to use

Add or override these options in a host `home.nix` under the `userSettings` attribute. Example:

```nix
userSettings = {
  browser = "brave";
  vscodium.enable = true;
  media.enable = true;
  virtualization.virtualMachines.enable = false;
};
```

Notes

- The TEMPLATE under `hosts/TEMPLATE/home.nix` demonstrates the default set you can copy per-host.
- Values are intentionally simple (strings and booleans) so hosts remain easy to read and maintain.