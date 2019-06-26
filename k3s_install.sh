#!/bin/bash

clear

wget https://github.com/rancher/k3s/releases/download/v0.5.0/k3s

chmod +x k3s

mv k3s /bin

sudo nohup  k3s server &>/dev/null &

echo "Sleeping while k3s starts up..."
sleep 15

curl -LO https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

k3s kubectl apply -f local-path-storage.yaml

sudo k3s kubectl delete -f /var/lib/rancher/k3s/server/manifests/traefik.yaml

cd src/helm

cp istio-init.tgz /var/lib/rancher/k3s/server/static/charts/istio-init.tgz

cp istio.tgz /var/lib/rancher/k3s/server/static/charts/istio.tgz

cd ../kube/

k3s kubectl apply -f 1.istio-namespace.yaml

k3s kubectl apply -f 2.istio-init.yaml

k3s kubectl apply -f 3.istio-main.yaml
