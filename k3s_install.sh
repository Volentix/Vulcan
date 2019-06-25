#!/bin/bash

clear

wget https://github.com/rancher/k3s/releases/download/v0.5.0/k3s

chmod +x k3s

mv k3s /bin

sudo k3s server &
