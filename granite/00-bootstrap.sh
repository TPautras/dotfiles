#!/usr/bin/env bash
set -euo pipefail

TARGET_USER="${SUDO_USER:-$(id -un)}"

echo "==> 1/6  Paquets de base"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y \
  ca-certificates curl gnupg git htop tmux ufw unattended-upgrades

echo "==> 2/6  Tailscale (réseau privé vers tes laptops)"
if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
echo "    → Lance ensuite manuellement :  sudo tailscale up"

echo "==> 3/6  Driver NVIDIA (propriétaire)"
apt-get install -y ubuntu-drivers-common
ubuntu-drivers install || echo "    (driver déjà installé ou aucun GPU NVIDIA détecté)"

echo "==> 4/6  Docker Engine + Compose (dépôt officiel)"
if ! command -v docker >/dev/null 2>&1; then
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
usermod -aG docker "$TARGET_USER" || true

echo "==> 5/6  NVIDIA Container Toolkit (GPU dans Docker)"
if [ ! -f /etc/apt/sources.list.d/nvidia-container-toolkit.list ]; then
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null
  apt-get update
fi
apt-get install -y nvidia-container-toolkit || echo "    (toolkit non installé — OK si pas de GPU)"
if command -v nvidia-ctk >/dev/null 2>&1; then
  nvidia-ctk runtime configure --runtime=docker
  systemctl restart docker
fi

echo "==> 6/6  Pare-feu (UFW)"
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8000/tcp
ufw allow in on tailscale0
ufw --force enable

echo
echo "✅ Bootstrap terminé."
echo "   • Reconnecte-toi (ou 'newgrp docker') pour que le groupe docker prenne effet."
echo "   • 'sudo tailscale up' pour rejoindre ton réseau Tailscale."
echo "   • Si tu as un GPU : teste avec"
echo "       docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu24.04 nvidia-smi"
echo "   • Puis lance  ./10-coolify.sh  pour installer Coolify."
