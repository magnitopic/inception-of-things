#!/bin/bash
set -e

SERVER_IP="$1"

echo "[INFO] Waiting for K3s Server to be ready..."

until ssh -o StrictHostKeyChecking=no vagrant@$SERVER_IP "sudo test -f /var/lib/rancher/k3s/server/node-token"; do
    sleep 2
done

# Get token
TOKEN=$(ssh -o StrictHostKeyChecking=no vagrant@$SERVER_IP "sudo cat /var/lib/rancher/k3s/server/node-token")

echo "[INFO] Installing K3s Worker..."
curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -

# Install kubectl stable version
echo "[INFO] Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

mkdir -p /home/vagrant/.kube
sudo scp -o StrictHostKeyChecking=no vagrant@$SERVER_IP:/etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

echo "[INFO] K3s Worker installation completed."
