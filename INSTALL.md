

# Notes: Installing k3s

Reference: https://dzone.com/articles/lightweight-kubernetes-k3s-installation-and-spring

## Get K3s

cd ~
mkdir k3sdownloads
cd k3sdownloads

Make sure you have get
```
which wget
```

should put
```
/usr/bin/wget
```

## Get K3S

You will need to replace <VERSION> with a valid K3s version from their release repository. You can get this information from the [the K3s release repository](https://github.com/rancher/k3s/releases)

```
wget https://github.com/rancher/k3s/releases/download/<VERSION>/k3s
```
For example, to get the v0.5.0 version, you would do the following:
```
wget https://github.com/rancher/k3s/releases/download/v0.5.0/k3s
```

Change the executable
```
chmod +x k3s
sudo mv k3s /bin
```

Test the install using the following from the command line.
```
k3s
```

You should receive an output showing the `k3s` help.

## Starting The Server


You will need to start the server with the following arguments:
```
sudo k3s server &
```
Test node:
```
sudo k3s kubectl get node
```

Test the instulation:
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

First you mist move the zipped charts into the `/var/lib/rancher/k3s/server/static/charts` folder.

The zip files can be found in the project root/src/helm directory.
```
cd src/helm
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