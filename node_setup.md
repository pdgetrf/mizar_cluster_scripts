this manual is used to set up test/dev nodes. the follwing is to be run as **root**.

### prerequisites
- DO NOT INSTALL OTHER CNI LIKE FLANNEL!!

### clone mizar

```bash
git clone https://github.com/CentaurusInfra/mizar.git
```

### update kernel
this takes some time. go get a coffee.
```
cd mizar/
./kernelupdate.sh

reboot
```

### iptables and swap off ([ref](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic))
```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
swapoff -a
```


### install kube stuff ([ref](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl))
```
apt-get update
apt-get install -y apt-transport-https ca-certificates curl

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
```

### install docker
```
apt -y install docker.io
```

#### create/configure /etc/docker/daemon.json to use systemd. ([ref](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker))

```bash
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl enable docker
systemctl daemon-reload
systemctl restart docker
```

### create cni file
```bash
mkdir -p /etc/cni/net.d
cat <<EOF | sudo tee /etc/cni/net.d/10-mizarcni.conf
{
        "cniVersion": "0.3.1",
        "name": "mizarcni",
        "type": "mizarcni"
}
EOF
```

### compiling Mizar
on the host where mizar is to be compiled, do the following:

#### install python and mizar dependencies
```bash
apt-get install -y sudo rpcbind rsyslog libelf-dev iproute2  net-tools iputils-ping bridge-utils ethtool curl python$pyversion lcov python$pyversion-dev python3-apt python3-testresources libcmocka-dev python3-pip
pip3 install kopf # may fail but okay
apt install libcmocka-dev
```

#### go to this commit

```
commit eb839b06f6a92e479d4e64e3eef5d5a609595753 (origin/dev-next, origin/HEAD)
Author: Phu Tran <22720475+phudtran@users.noreply.github.com>
Date:   Mon Sep 13 13:50:50 2021 -0700

    Add dev deploy yaml (#536)
```
This is a "recent enough" commit for edge. Commits later than this seems to have new compiling dependency which I didn't find time to figure out.  

### hacky steps to set up cni on a host
1. start the kubeadm cluster as usual, and join the new node to the cluster. **it's okay the node is in NotReady state**
2. install mizar.goose.yaml using kubectl. this will deploy a daemonset pod on the new node. this pod installs some needed software in */var/mizar*
3. on the new node, run
```bash
pip3 install --ignore-installed /var/mizar/
```
this will take some time (especially on step "Running setup.py bdist_wheel for grpcio ..."). not entirely sure what's being compiled and installed, but after this, node should be in Ready state.

### on the node where mizar is compiled, most likely the master node, install dev tools
```bash
apt-get install -y build-essential clang-7 llvm-7 libelf-dev python3.8 python3-pip libcmocka-dev lcov python3.8-dev python3-apt pkg-config
python3 -m pip install --user grpcio-tools
```

### bash export
add
```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```
to ~/.bashrc on the master node (again, this should be in the root account)
