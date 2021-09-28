This repo is to help setup the dev environment for edge networking. 

Roughly there are two ways to use. 

### Start or restart the cluster
To set up a node (master or slave), follow [the node setup guide](https://github.com/pdgetrf/mizar_cluster_scripts/blob/main/node_setup.md).

To setup a kubeadm cluster:

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

And that's it. No, really! It takes care of making sure proper cleaning up is done, the correct VNI is used and all those tedious jazz.

This brings up a kubeadm cluster with slave nodes from the slave.in file, install Mizar, provision a new vpc with 2 subnets (using the correct CNI)

Here's an example of what it sets up:

![image](https://user-images.githubusercontent.com/252020/132430804-d0da365b-faa7-4569-a2cc-a3f0e783f537.png)

And here's the usage and outputs:

![image](https://user-images.githubusercontent.com/252020/132586722-27861eb3-a41d-4f76-849a-fc22b5b2b18a.png)

### Run with indivisual scripts 
Alternatively, one could use the following scripts for the task of

1. rebuild the images and then update on all slave hosts
2. restart the cluster
3. create the 192.168.0.0/16 vpc and two subnets (192.168.0.0/24 and 192.168.122.0/24)
4. create one pod in each of the two subnets

```bash
./build_docker_image.sh && ./restart_cluster.sh && ./create_vpc_nets.sh && ./create_pods.sh
```

### Pings

Two scripts are provided to initiate pings.

1. ping_122.sh, this pings the pod in the .122 subnet from the pod in the .0 subnet
2. ping_0.sh, you guessed it! this pings the pod in the .0 subnet from the pod in the .122 subnet
