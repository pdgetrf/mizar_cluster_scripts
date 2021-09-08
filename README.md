### This repo is to help setup a cluster and run Mizar

To set up a node (master or slave), follow [the node setup guide](https://github.com/pdgetrf/mizar_cluster_scripts/blob/main/node_setup.md).

To start a kubeadm cluster, log into the master node and run

```bash
./mizar_cluster_up.sh
```

And that's it. No, really!

This brings up a kubeadm cluster with two slave nodes, install Mizar, provision a new vpc with 2 subnets (using the correct CNI)

Here's an example of what it sets up:

![image](https://user-images.githubusercontent.com/252020/132430804-d0da365b-faa7-4569-a2cc-a3f0e783f537.png)
