

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

## Creating An Alias

You will want to create an alias on your machine. Basically, for every command you need to write `k3s kubectl` if you don't.

This document assumes that you will create an alias and so, all `k3s kubectl` statements will be replaced with the simple `k`.

You can do it in one of two ways.

### Short Term

This alias is only usefull while you remain within one session of the terminal. Meaning, you will need to reset this alias upon launching a new terminal.

Run the following on the command line:
```
alias k="k3s kubectl"
```

### Long Term

This will allow any terminal access to the `k` alias.

Open bashrc (I am using pico but you can choose whatever you like to edit):
```
sudo pico ~/.bashrc
```

Once open, add the following to the file:
```
alias k="k3s kubectl"
```

Refresh the terminal you are in:
```
source ~/.bashrc
```

### Test The Alias

To test the alias, as well as view all the objects of the system, type:
```
k get all --all-namespaces
```

You should see a fairly verbose output

## Installing VDEX

### Install

Run the Kube scripts
0.XXX.yaml

Get local storage for your device

curl -LO https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

run the scipt
```
k apply -f local-path-storage.yaml
```

# NOTES BitcoinD:
bitcoind RPC can be accessed via port 8332 on the following DNS name from within your cluster:
my-release-bitcoind.default.svc.cluster.local

To connect to bitcoind RPC:

1. Forward the port for the node:

  $ kubectl port-forward --namespace default $(kubectl get pods --namespace default -l "app=bitcoind,release=my-release" -o jsonpath="{ .items[0].metadata.name }") 8332

2. Test connection with user and password provided in configuration file:

  $ curl --user rpcuser:rpcpassword -k http://127.0.0.1:8332 --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }' -H 'content-type: text/plain;'
