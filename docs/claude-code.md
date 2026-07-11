# Exploiter Claude Code à fond sur ce repo

Guide pratique pour tirer le maximum de l'agent Claude Code (CLI / extension) sur cette config
NixOS. Tout ce qui suit est utilisable directement ici.

---

## 1. Le modèle mental

Claude Code est un agent qui **lit, écrit et exécute** dans ton repo. Trois leviers pour monter
en puissance :

1. **Plan mode** — l'agent explore et propose un plan avant de toucher au code (tu valides d'abord).
2. **Subagents** — déléguer une sous-tâche à un agent isolé (recherche, design, review) en parallèle.
3. **Skills & hooks** — encoder des workflows répétables (rebuild, check) et des automatismes.

Règle d'or NixOS : demande-lui de **`nix flake check` / `nixos-rebuild build`** après chaque
changement — c'est la boucle de feedback qui remplace les tests.

---

## 2. Plan mode

Active-le pour tout changement non trivial (migration, nouveau module, refactor). L'agent :

- lance des agents **Explore** en lecture seule pour cartographier le code,
- écrit un plan dans un fichier,
- te le fait valider via un écran d'approbation avant d'exécuter.

Quand l'utiliser ici : « migre vers Hyprland », « ajoute un host », « extrait la palette ».
Quand l'éviter : un one-liner (corriger une faute, changer une valeur).

---

## 3. Subagents (déléguer et paralléliser)

Tu peux demander explicitement à Claude d'utiliser un subagent. Types utiles :

| Agent | Usage | Écrit ? |
|-------|-------|---------|
| **Explore** | balayer plein de fichiers, trouver « où est X » | non (lecture seule) |
| **Plan** | concevoir une stratégie d'implémentation | non |
| **general-purpose** | tâche multi-étapes complète | oui |

Exemples de prompts :

- « Utilise un subagent Explore pour trouver tous les endroits qui référencent l'ancienne palette Everforest. »
- « Lance 2 agents Explore en parallèle : l'un cartographie `modules/system`, l'autre `modules/home`. »

Les subagents ont leur propre contexte : parfaits pour une recherche large sans polluer la
conversation principale. Ils démarrent « à froid » — donne-leur le contexte nécessaire.

---

## 4. Boucles (`/loop`)

La skill `/loop` répète un prompt ou une slash-command, sur un intervalle ou en auto-rythme.

```
/loop 5m surveille `journalctl -u tailscaled` et préviens-moi si le service tombe
/loop lance `nix flake check`, corrige la première erreur, recommence jusqu'à ce que ça passe
```

- Avec intervalle (`5m`, `30s`) → utile pour **poller** un état externe (build, déploiement).
- Sans intervalle → l'agent choisit lui-même quand relancer (auto-pacé), utile pour une tâche
  « jusqu'à ce que ce soit vert ».

Cas typiques ici : surveiller un `nixos-rebuild` long, boucler sur `nix flake check` jusqu'à 0 erreur,
attendre qu'un host distant redevienne joignable après un rebuild.

---

## 5. Skills

Une **skill** est un dossier avec un `SKILL.md` (frontmatter `name` + `description`) qui encode
un mode d'emploi réutilisable. Claude la déclenche quand la description matche ta demande, ou tu
l'invoques avec `/<nom>`.

Ce repo fournit des skills NixOS dans [`.claude/skills/`](../.claude/skills/) :

| Skill | Rôle |
|-------|------|
| `/nix-check` | `nix flake check` + `nix eval` des toplevels des hosts |
| `/nix-rebuild` | rebuild `build`/`test`/`switch` d'un host, avec check préalable |
| `/nix-update` | `nix flake update` puis rebuild de test |
| `/nix-add-feature` | scaffold un nouveau feature module selon le pattern du repo |

**Ajouter ta propre skill** :

```
.claude/skills/mon-skill/SKILL.md
```

```markdown
---
name: mon-skill
description: Quand l'utiliser, en une phrase déclencheuse.
---

Instructions étape par étape que Claude suit quand la skill est active.
```

Skills built-in utiles ici : `/code-review` (revue du diff), `/security-review`,
`/verify` (exercer un changement de bout en bout), `/init` (générer un CLAUDE.md).

---

## 6. Hooks & settings (automatismes)

`.claude/settings.json` configure le harness : **permissions**, variables d'env, et **hooks**
(commandes exécutées automatiquement sur un événement — ex. formater après édition).

Ce repo pré-autorise les commandes de lecture Nix fréquentes (`nix flake check`, `nix eval`,
`git status`) pour réduire les demandes de permission. Voir [`.claude/settings.json`](../.claude/settings.json).

Exemple de hook « formate le Nix après chaque écriture » (à ajouter dans `settings.json`) :

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "nixfmt \"$CLAUDE_FILE_PATH\" 2>/dev/null || true" }]
      }
    ]
  }
}
```

Les automatismes du type « à chaque fois que X, fais Y » passent **toujours** par un hook
(c'est le harness qui les exécute, pas la mémoire de Claude).

---

## 7. Mémoire persistante

Claude garde une mémoire de fichiers entre sessions (profil utilisateur, préférences, contexte
projet). Utile pour lui rappeler des faits non déductibles du code : « le serveur Granite n'est
plus sous NixOS », « je préfère rofi à wofi ». Dis-lui simplement « retiens que… ».

---

## 8. Recette pour ce repo

1. **Changement isolé** : demande direct, puis « lance `nix flake check` ».
2. **Changement structurant** : plan mode → validation → implémentation → `nixos-rebuild build`.
3. **Recherche large** : « utilise Explore pour… ».
4. **Boucle de correction** : `/loop` sur `nix flake check` jusqu'à vert.
5. **Tester le bureau** : `nixos-rebuild build-vm --flake .#jade` puis lance la VM.
6. **Revue avant commit** : `/code-review`.

---

## 9. Ressources

- Doc Claude Code : https://docs.claude.com/en/docs/claude-code
- Skills : https://docs.claude.com/en/docs/claude-code/skills
- Hooks : https://docs.claude.com/en/docs/claude-code/hooks
