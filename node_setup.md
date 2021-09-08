this manual is used to set up test/dev nodes.

### !!DO NOT INSTALL OTHER CNI LIKE FLANNEL!!

the follwing is to be run as **root**.

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

#### edit /etc/docker/daemon.json to use systemd. ([ref](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker))

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
