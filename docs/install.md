# Vulcan Install
The following guide you though the installation of Vulcan on your PC.

## Before You Begin

This tutorial assumes that you are running Linux on your machine and that you have some basic knowledge of git.

## Make Workspace
k3sdownloads
Create a workspace to manage the download of code and operational artifacts.

Go to your home directory:
```
cd ~
```

Create the k3sdownloads directory.
```
mkdir k3sdownloads
```

Navigate to the new directory:
```
cd k3sdownloads
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

Inside the k3sdownloads directory, run the command:
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

## Install Istio

### Move Helm Charts

First you mist move the zipped charts into the `/var/lib/rancher/k3s/server/static/charts` folder.

The zip files can be found in the project root/src/helm directory. If you created the k3sdownloads in the home directory, you can use the following.
```
cd ~/k3sdownloads/Vulcan/src/helm
```

Next copy the files over to the charts directory:
```
cp istio-init.tgz /var/lib/rancher/k3s/server/static/charts/istio-init.tgz
cp istio.tgz /var/lib/rancher/k3s/server/static/charts/istio.tgz
```

Once this is complete, cd back unt the src/kube directory

### Set Up The Namespace

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