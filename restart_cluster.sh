#!/bin/bash


slavehosts="./slaves.in"
cleanuplog=/tmp/cleanup.out
kubeadmresetlog=/tmp/kubeadm_reset.out
kubeadminitlog=/tmp/kubeadm_init.out
kubeadmjoinlog=/tmp/kubeadm_join.out
mizarlog=/tmp/mizar.out

echo "---- verifying slave host file exist ----"
if [ ! -f "$slavehosts" ]; then
    echo "$slavehosts does not exist."
    echo "put IPs of slave hosts in a file called **slave.in** and try again."
    echo "exited on purpose."
    exit
fi

rm -f /tmp/*.out

echo "---- resetting and cleaning up slave nodes ----"
while IFS= read -r slave
do
    echo "-- nuking slave $slave --"
    ssh -n $slave "kubeadm reset -f"|tee $kubeadmresetlog
    scp ./cleanup.sh $slave:/tmp
    ssh -n $slave "/tmp/cleanup.sh"|tee $cleanuplog
done < "$slavehosts"

echo "---- resetting master node----"
kubeadm reset -f | tee $kubeadmresetlog 

echo "---- starting master node----"
kubeadm init --pod-network-cidr 20.0.0.0/16|tee $kubeadminitlog 

echo "---- joining slave nodes ----"
token=`cat $kubeadminitlog|grep "\-\-token "|awk '{print $5}'`
master=`cat $kubeadminitlog|grep "\-\-token "|awk '{print $3}'`
certhash=`cat $kubeadminitlog|grep "discovery-token-ca-cert-hash"|awk '{print $2}'`
joincmd="kubeadm join $master --token $token --discovery-token-ca-cert-hash $certhash"

echo "joining with '$joincmd'"

while IFS= read -r slave
do
    echo "-- joining from $slave --"
    ssh -n $slave "$joincmd"|tee $kubeadmjoinlog
done < "$slavehosts"

echo "---- installing mizar ----"
kubectl create -f mizar.dev.yaml|tee $mizarlog

