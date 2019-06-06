# Vulcan Install
The following guide you though the installation of Vulcan on your PC.

## Before You Begin

This tutorial assumes that you are running Linux on your machine and that you have some basic knowledge of git.

## Make Workspace

Create a workspace to manage the download of code and operational artifacts.

Go to your home directory:
```
cd ~
```

Create the downloads directory.
```
mkdir downloads
```

Navigate to the new directory:
```
cd downloads
```

Make sure you have the wget application:
```
which wget
```

If you do not receive the following, you will need to install it.
```
/usr/bin/wget
```
## Clone Vulcan

You will need to clone Vulcan to get some of the helm charts as well as the yaml files required to run Vulcan.

Inside the downloads directory, run the command:
```
git clone https://github.com/Volentix/Vulcan.git
```

## Get K3S

[K3s](https://k3s.io/) is a very, very small version of Kubernetes. However, don't be fooled by its size. In short, K3s removes all the legacy code and not relivant code that has bloated kubernetes. For example, alpha releases are not supported. Similarily, cloud native service provider interfaces.

These limitations do not impeded Vulcan but rather empower it.

To install K3s, run the following, replacing the <VERSION> with a [valid k3s release](https://github.com/rancher/k3s/releases)
```
wget https://github.com/rancher/k3s/releases/download/<VERSION>/k3s
```

For example, to get the v0.5.0 version, you would do the following:
```
wget https://github.com/rancher/k3s/releases/download/v0.5.0/k3s
```

Make the downloaded k3s binary executable:
```
chmod +x k3s
```

Move it to the system path for programs:
```
sudo mv k3s /bin
```

Test the install using the following from the command line.
```
k3s
```

You should receive an output showing the `k3s` help documentation.

## Start The Server


Start the server and run it in the background:
```
sudo k3s server &
```
Give the server a few seconds to launch, and then test that the node has been created. If it has not, wait a few more seconds.
```
sudo k3s kubectl get node
```

Now that you know the node is up and running, you can test the infrustructure to make sure everything is running.
```
sudo k3s kubectl --all-namespaces=true get all
```

 ## Install Local Storage

K3s does not ship with a default storage driver, however, they do supply a simple one for local storage. For now, this will be fine, however, in time, once larger Vulcan servers come on line, the operator will be able to plug in their own prefered storage driver.

To get local storage for your device download the script as follows:
```
curl -LO https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```
Once the script is available locally, you can run the following scipt:
```
k3s kubectl apply -f local-path-storage.yaml
```

## Delete Traefik

K3s bundles with [Traefik](https://traefik.io/), however, we will be using Istio instead.

First run the following too see if Traefik pod is running.
```
k get  po -n kube-system
```

You should see a record similar (the prefix on traefik- will different) to the following:
```
kube-system          traefik-55bd9646fc-xsdq7                  1/1     Running     0          15m
```

To remove Traefik you will need access to the root account.
```
sudo k3s kubectl delete -f /var/lib/rancher/k3s/server/manifests/traefik.yaml
```

Now run the get pods command again:
```
k get  po -n kube-system
```

You should no longer see the traefik pod running.

## Install Istio

### Move Helm Charts

First you mist move the zipped charts into the `/var/lib/rancher/k3s/server/static/charts` folder.

The zip files can be found in the project root/src/helm directory. If you created the downloads in the home directory, you can use the following.
```
cd ~/downloads/Vulcan/src/helm
```

Next copy the files over to the charts directory:
```
sudo cp istio-init.tgz /var/lib/rancher/k3s/server/static/charts/istio-init.tgz
sudo cp istio.tgz /var/lib/rancher/k3s/server/static/charts/istio.tgz
```

### Set Up The Namespace

Move to the kube directory.
```
cd ~/downloads/Vulcan/src/kube
```

Set up the namespace for Istio components to run within.
```
k3s kubectl apply -f 1.istio-namespace.yaml
```

### Init Istio

Next init istio and install all the CRD's required to run istio
```
k3s kubectl apply -f 2.istio-init.yaml
```

### Main Istio

Next install istio and its components.
```
k3s kubectl apply -f 3.istio-main.yaml
```
Isto is now integrated into K3s and you can begin your development against it.

## Istio Auto Magic Injection

Namespaces, such as vdex, will need to label themselves with the `istio-injection=enabled`. With this annotation, pods deployed will be injected with the appropriate envoy cartridges to capture telemetry metrics and manage security.