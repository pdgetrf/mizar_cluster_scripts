this manual is used to set up test/dev nodes.

### !!DO NOT INSTALL OTHER CNI LIKE FLANNEL!!

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

### iptables and swap off (ref from [this](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic))
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


### install kube stuff (ref from [this](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl))
```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

### install docker
```
apt  install docker.io
```

#### edit /etc/docker/daemon.json to use systemd. It should look like this:
```
root@ip-172-31-6-231:/home/ubuntu# cat /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
```

#### reload daemon
```bash
systemctl daemon-reload
systemctl restart docker
```
