#!/usr/bin/env bash
set -euo pipefail

echo "==> Installation de Coolify"
curl -fsSL https://cdn.coolify.io/install.sh | bash

echo
echo "✅ Coolify installé."
echo "   • UI :  http://<IP_LAN_OU_TAILSCALE>:8000"
echo "   • Crée ton compte admin à la première connexion."
echo "   • Pour exposer des apps sur un domaine : Coolify → Settings → Domain"
echo "     (Let's Encrypt automatique via Traefik)."
echo
echo "   GPU dans Coolify : dans une ressource, active 'Use GPU' (ou ajoute"
echo "   un Docker Compose avec 'deploy.resources.reservations.devices' nvidia)."
