# Installer NixOS sur heimdall (dual-boot Windows)

Guide complet, de la clé USB au premier jeu lancé.

**Contexte** : tour AMD (CPU + GPU), Windows déjà installé sur un disque, NixOS sur un
**autre disque physique**. Partitionnement par disko, donc le disque NixOS est effacé
intégralement.

> ⚠️ Si Windows et NixOS devaient partager le même disque, **n'utilise pas disko** :
> il écraserait Windows. Ce guide suppose deux disques séparés.

---

## Étape 0 — Préparer Windows (à faire AVANT de redémarrer)

Trois choses, dans cet ordre. Les deux premières sont obligatoires, la troisième dépend
de ta machine.

### 0.1 Désactiver le démarrage rapide

C'est **le** piège du dual-boot. Le "démarrage rapide" ne fait pas un vrai arrêt : il
hiberne Windows. Le système de fichiers reste marqué comme monté, et si Linux y touche,
tu corromps des données.

```
Panneau de configuration
  → Options d'alimentation
  → Choisir l'action des boutons d'alimentation
  → Modifier des paramètres actuellement non disponibles
  → décocher « Activer le démarrage rapide »
```

Vérifie ensuite dans un PowerShell **administrateur** :

```powershell
powercfg /h off
```

### 0.2 BitLocker

Si le chiffrement BitLocker est actif, modifier l'ordre de boot peut déclencher une
demande de clé de récupération au prochain démarrage de Windows.

```powershell
manage-bde -status
```

Si c'est activé : soit tu le suspends (`manage-bde -protectors -disable C: -rebootcount 2`),
soit tu récupères ta clé de récupération sur https://aka.ms/myrecoverykey **avant** de
continuer. Ne saute pas cette étape si tu ne veux pas te retrouver enfermé dehors.

### 0.3 Repérer tes disques

Ouvre `diskmgmt.msc` (Gestion des disques) et note :

- sur quel disque physique est Windows (Disque 0, 1, … avec sa taille)
- quel disque tu veux dédier à NixOS, et **sa taille exacte**

La taille est ce qui te permettra d'identifier le bon disque sous Linux. Note-la.

---

## Étape 1 — Créer la clé USB

### Télécharger l'ISO

https://nixos.org/download → **NixOS Minimal ISO image**, 64-bit Intel/AMD.

L'ISO minimal suffit (on installe en ligne de commande). Si tu préfères avoir un
navigateur sous la main pendant l'install, prends l'ISO Graphical GNOME.

### Flasher, depuis Windows

Avec **Rufus** (https://rufus.ie) :

1. Périphérique : ta clé USB (⚠️ elle sera effacée)
2. Sélection du démarrage : l'ISO NixOS
3. Schéma de partition : **GPT**
4. Système de destination : **UEFI (non CSM)**
5. DÉMARRER → si Rufus propose « Écrire en mode Image ISO », accepte
6. Attendre, puis éjecter proprement

### Ou depuis jade / cobble

```bash
lsblk                                    # identifier la clé (ex. /dev/sdb)
sudo dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

`/dev/sdX` = **le disque entier**, pas une partition (`sdb`, pas `sdb1`). Vérifie deux
fois : `dd` ne demande pas confirmation.

---

## Étape 2 — Régler le BIOS/UEFI

Redémarre et entre dans le BIOS (`Suppr`, `F2` ou `F10` selon la carte mère — le message
s'affiche une seconde au démarrage).

| Réglage | Valeur | Pourquoi |
|---------|--------|----------|
| **Secure Boot** | **Disabled** | NixOS ne le supporte pas sans lanzaboote |
| **CSM / Legacy Boot** | Disabled | on installe en UEFI pur |
| **SATA Mode** | AHCI (pas RAID/IRST) | sinon Linux ne voit pas les disques |
| **TPM** | peut rester activé | — |

Sauvegarde et redémarre.

Puis appelle le **menu de démarrage** (`F8`, `F11` ou `F12` selon la carte) et choisis ta
clé USB en mode **UEFI**. Si deux entrées apparaissent pour la clé, prends celle
préfixée `UEFI:`.

---

## Étape 3 — Démarrer le live USB

Tu arrives sur un shell. Passe en root :

```bash
sudo -i
```

### Réseau

En ethernet, ça marche tout seul. Vérifie :

```bash
ping -c3 nixos.org
```

En wifi :

```bash
systemctl start wpa_supplicant
wpa_cli
> add_network
> set_network 0 ssid "NomDuReseau"
> set_network 0 psk "motdepasse"
> enable_network 0
> quit
```

Ou plus simple si disponible : `nmtui`.

### Clavier français

L'ISO est en QWERTY par défaut :

```bash
loadkeys fr
```

---

## Étape 4 — ⚠️ Identifier le bon disque

**C'est l'étape à ne pas rater.** Tout ce qui suit détruit des données.

```bash
lsblk -o NAME,SIZE,MODEL,SERIAL,PARTLABEL
```

Repère :

- le disque **Windows** — il a des partitions nommées `EFI system partition`,
  `Microsoft reserved`, `Basic data partition`
- le disque **cible** — celui dont la taille correspond à ce que tu as noté à l'étape 0.3

Confirme que le disque Windows contient bien Windows :

```bash
mkdir -p /tmp/win && mount /dev/sdXN /tmp/win && ls /tmp/win && umount /tmp/win
```

Si tu vois `Windows/`, `Program Files/` — c'est celui-là, **on n'y touche pas**.

La config suppose que le disque NixOS est `/dev/nvme0n1`. **Si ce n'est pas le cas**,
il faudra corriger `device` dans `modules/hosts/heimdall/disko.nix` à l'étape suivante.

> Astuce : préfère un identifiant stable à `/dev/nvme0n1`, qui peut changer d'ordre
> entre deux démarrages :
> ```bash
> ls -l /dev/disk/by-id/
> ```
> et utilise `/dev/disk/by-id/nvme-Samsung_SSD_...` dans `disko.nix`.

---

## Étape 5 — Récupérer la config

```bash
nix-shell -p git
git clone https://github.com/TPautras/dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles
```

Si le disque cible n'est pas `/dev/nvme0n1` :

```bash
nix-shell -p vim
vim modules/hosts/heimdall/disko.nix     # corriger `device`
git add -A && git commit -m "fix: disque heimdall"
```

> **Le commit est obligatoire.** Un flake ne voit que les fichiers suivis par git ;
> une modification non commitée est simplement ignorée.

---

## Étape 6 — Partitionner (destructif)

Dernière chance de vérifier le disque.

```bash
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode destroy,format,mount \
  --flake .#heimdall
```

Ça crée une ESP de 1 Go + une racine ext4, et monte le tout sous `/mnt`.

Vérifie :

```bash
lsblk
mount | grep /mnt
```

Tu dois voir `/mnt` et `/mnt/boot`.

---

## Étape 7 — Générer le hardware config réel

Le fichier du repo est un template générique. Il faut le remplacer par ce que la machine
détecte vraiment (contrôleurs disque, etc.).

```bash
nixos-generate-config --no-filesystems --root /mnt --show-hardware-config
```

`--no-filesystems` est important : c'est disko qui fournit les `fileSystems`, on ne veut
pas de doublon.

Recopie la ligne `boot.initrd.availableKernelModules` obtenue dans
`modules/hosts/heimdall/hardware-configuration.nix`, en **gardant l'enrobage** :

```nix
{ self, inputs, ... }: {
  flake.nixosModules.heimdallHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ ... ];   # ← la ligne détectée
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules        = [ "kvm-amd" ];
    boot.extraModulePackages  = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
```

Puis :

```bash
git add -A && git commit -m "feat: hardware config heimdall"
```

---

## Étape 8 — Installer

```bash
nixos-install --flake .#heimdall
```

Ça va télécharger beaucoup (Steam, Proton, le bureau…). Compte 20 à 60 min selon la
connexion.

À la fin, il demande un mot de passe **root**. Le compte `thomas` a déjà le mot de passe
défini dans `sys.user.hashedPassword` (le même que sur tes laptops).

```bash
reboot
```

Retire la clé USB.

---

## Étape 9 — Premier démarrage

Tu arrives sur **tuigreet**. Connecte-toi en `thomas`, tu tombes sur Hyprland.

### Choisir entre NixOS et Windows

Les deux OS ont chacun leur ESP sur leur propre disque, et systemd-boot ne détecte pas
Windows sur un autre disque. Donc :

- **NixOS démarre par défaut** (menu systemd-boot visible 5 s — `boot.loader.timeout = 5`
  dans `heimdall/config.nix`, qui permet aussi de choisir une génération précédente)
- **Pour Windows** : menu de démarrage de la carte mère (`F8`/`F11`/`F12`) et choisir le
  disque Windows

Si tu préfères que Windows soit l'OS par défaut, change l'ordre de boot dans le BIOS —
le menu NixOS restera accessible via le même menu de démarrage.

### L'heure

`time.hardwareClockInLocalTime = true` est déjà positionné pour heimdall : c'est ce qui
évite les 2 h de décalage entre Windows et NixOS après chaque bascule.

---

## Étape 10 — Post-installation

### Rapatrier la config au bon endroit

Le repo doit être en `~/.dotfiles` (c'est ce que `nh`, les binds `$hyper` et le lien
Neovim attendent) :

```bash
git clone https://github.com/TPautras/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Neovim

Au premier lancement, lazy.nvim installe tous les plugins :

```bash
nvim
```

Laisse-le finir, puis commite le lockfile généré :

```bash
cd ~/.dotfiles && git add nvim/lazy-lock.json && git commit -m "chore: lazy lock heimdall"
```

### Steam

1. Lance Steam, connecte-toi
2. `Steam → Paramètres → Compatibilité` → activer **Proton Experimental** ou **GE-Proton**
3. Pour l'overlay de perfs, dans les options de lancement d'un jeu :
   ```
   mangohud %command%
   ```
4. Avec gamemode :
   ```
   gamemoderun mangohud %command%
   ```

### Vérifier que le GPU AMD fonctionne

```bash
vulkaninfo | grep deviceName
glxinfo | grep "OpenGL renderer"
```

Tu dois voir ta carte AMD (RADV). Si ça affiche `llvmpipe`, c'est du rendu logiciel :
le pilote n'est pas chargé, vérifie `boot.initrd.kernelModules = [ "amdgpu" ]`.

---

## Dépannage

**Le live USB ne démarre pas** → Secure Boot encore actif, ou clé flashée en MBR au lieu
de GPT.

**`nixos-install` échoue sur un paquet** → souvent un binaire non mis en cache. Relance,
ou `--option substitute true`.

**Écran noir après le premier boot** → passe en TTY (`Ctrl+Alt+F2`), connecte-toi, et
regarde :
```bash
journalctl -b -p err
systemctl status greetd
```

**Windows ne démarre plus** → il est intact sur son disque, c'est l'ordre de boot UEFI
qui a changé. BIOS → Boot Order → remets le Windows Boot Manager en premier.

**Décalage d'horloge après retour de Windows** →
```bash
sudo hwclock --systohc --localtime
```

**Revenir en arrière après un rebuild raté** → au démarrage, menu systemd-boot (5 s),
choisis une génération précédente.
