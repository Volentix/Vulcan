# Vulcan Install
The following guide you though the installation of Vulcan on your PC.

## Before You Begin

This tutorial assumes:

1. You are running Linux. Officially, we support Ubuntu 17.10 and 18.04.
2. Docker is installed.
3. Git is installed.

## Install Vulcan

Clone Vulcan:
```bash
git clone https://github.com/Volentix/Vulcan.git
```

Change into the Vulcan directory.
```bash
cd Vulcan
```
Note that you will need to use `sudo` to run these commands.

Install [K3s](https://k3s.io/) and run it.
```bash
sudo ./k3s_install.sh
```

This script will download and start K3s in the terminal. Keep this terminal open and open another terminal.

Install Vulcan.

```bash
sudo ./vulcan_install.sh
```

You now have Vulcan installed on your machine. Now you may install vDexNode

### Istio Auto Magic Injection

Namespaces, such as vdex, will need to label themselves with the `istio-injection=enabled`. With this annotation, pods deployed will be injected with the appropriate envoy cartridges to capture telemetry metrics and manage security.

## Install vDexNode

Once Vulcan is installed, install Vulcan. Note that the install of Vulcan will require 2 command line arguments.

1. **eos_public_address:** Your public address on EOS that will be credited.
2. **namespace:** You are able to install multiple instances of vdex on one Vulcan install, however, each instance will require its own namespace. Namespaces are named logic partisions on Vulcan. You cannot deploy multiple versions of vdex into the same namespace. If this is unclear, just use `vdex` as your namespace. Please note that namespaces CANNOT have spaces of special chars in them. For now the script is pretty bare so please be careful.

As a helper, you can use the shell script to deploy your cluster. Future, more advanced scripts will be built on Helm but for now this should get us going.

To begin, you will need to change to the parent directory:
```bash
cd ../
```

Clone the vDexNode repo:
```bash
git clone git@github.com:Volentix/vDexNode.git
```

Change into the kube directory:
```bash
cd vDexNode/kube
```

Next deploy vdex with the shell script. Note replace `YOUR_EOS_PUBLIC_ADDRESS` with your eos address. Also, replace the`YOUR_NAMESPACE` with one of your choosing:
```bash
./deploy.sh YOUR_EOS_PUBLIC_ADDRESS YOUR_NAMESPACE
```

The script will create the yaml files in a directory called deploy. It then runs the kubernetes intall commands. Note that the files are kept in case inspection is desired, however, they will be ignored by git.

### Usaging vDexNode

If you have installed vDex on Vulcan, you will need to run open up some ports to communicate with vDex. This is not necessary with the docker install. Note this restriction will be removed in a future release.

As above, replace the `YOUR_NAMESPACE` below with the namespace you are using. Note that it appears twice in the commands.

#### Get Node Info

To the the node info, you will need to run the following if you have deployed on **Vulcan**.
```bash
k3s kubectl -n YOUR_NAMESPACE port-forward $(k3s kubectl -n YOUR_NAMESPACE get pod -l app=vdex-node -o jsonpath='{.items[0].metadata.name}') 8100:8100
```

You can then curl the instance for the nodes information:
```bash
curl http://localhost:8100
```
#### Scan Nodes

To the the list of nodes, you will need to run the following if you have deployed on **Vulcan**.
```bash
k3s kubectl -n YOUR_NAMESPACE port-forward $(k3s kubectl -n YOUR_NAMESPACE get pod -l app=vdex-node -o jsonpath='{.items[0].metadata.name}') 9080:9080
```

You can then curl the instance:
```bash
curl http://localhost:9080/getConnectedNodes
```
#### Kiali

If you have installed vdex on Vulcan, you can open up the Kiali dashboard to get information about the cluster. First open the port:
```bash
k3s kubectl -n istio-system port-forward $(k3s kubectl -n istio-system get pod -l app=kiali -o jsonpath='{.items[0].metadata.name}') 20001:20001
```

You can now, in the web browser of your choosing, open up the dashboard. Note that the default username and password are both `admin`.
```bash
http://localhost:20001/kiali/console/
```