### This repo is to help setup a cluster and run Mizar

To set up a node (master or slave), follow [the node setup guide](https://github.com/pdgetrf/mizar_cluster_scripts/blob/main/node_setup.md).

To start a kubeadm cluster:

- make sure you can ssh from master to all slave hosts without password. follow [this](http://www.linuxproblem.org/art_9.html) if not. 
- put IPs of slave hosts in a file called **slave.in**. for example:
```bash
root@ip-172-31-7-100:~/testing# cat slaves.in
18.237.157.249
18.237.205.30
```

- log into the master node and run

```bash
./mizar_cluster_up.sh
```

And that's it. No, really!

This brings up a kubeadm cluster with slave nodes from the slave.in file, install Mizar, provision a new vpc with 2 subnets (using the correct CNI)

Here's an example of what it sets up:

![image](https://user-images.githubusercontent.com/252020/132430804-d0da365b-faa7-4569-a2cc-a3f0e783f537.png)
