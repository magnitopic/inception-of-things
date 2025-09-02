#!/bin/bash
set -e

echo "[INFO] Installing K3s Server..."
curl -sfL https://get.k3s.io | sh -

# Install kubectl stable version
echo "[INFO] Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

echo "[INFO] K3s Server installation completed."