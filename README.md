### This repo is to help setup a cluster and run Mizar

To set up a node (master or slave), follow [the node setup guide](https://github.com/pdgetrf/mizar_cluster_scripts/blob/main/node_setup.md).

To start a kubeadm cluster, log into the master node and run

```bash
./mizar_cluster_up.sh
```

This brings up a kubeadm cluster with two slave nodes, install Mizar, provision a new vpc with 2 subnets.
