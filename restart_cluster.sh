#!/bin/bash

set -e

rm -f /tmp/*.out

slave1=18.237.157.249
slave2=18.237.205.30

echo "-- resetting slave nodes --"
ssh $slave1 "kubeadm reset -f"|tee $kubeadmresetlog
ssh $slave2 "kubeadm reset -f"|tee $kubeadmresetlog

echo "-- cleaning up on slave nodes --"
cleanuplog=/tmp/cleanup.out
scp ./cleanup.sh $slave1:/tmp
scp ./cleanup.sh $slave2:/tmp
ssh $slave1 "/tmp/cleanup.sh"|tee $cleanuplog
ssh $slave2 "/tmp/cleanup.sh"|tee $cleanuplog

echo "-- resetting master node--"
kubeadmresetlog=/tmp/kubeadm_reset.out
kubeadm reset -f | tee $kubeadmresetlog 

echo "-- starting master node--"
kubeadminitlog=/tmp/kubeadm_init.out
kubeadm init --pod-network-cidr 20.0.0.0/16|tee $kubeadminitlog 

echo "-- joining slave nodes --"
token=`cat $kubeadminitlog|grep "\-\-token "|awk '{print $5}'`
master=`cat $kubeadminitlog|grep "\-\-token "|awk '{print $3}'`
certhash=`cat $kubeadminitlog|grep "discovery-token-ca-cert-hash"|awk '{print $2}'`
joincmd="kubeadm join $master --token $token --discovery-token-ca-cert-hash $certhash"
kubeadmjoinlog=/tmp/kubeadm_join.out

echo "joining with '$joincmd'"

ssh $slave1 "$joincmd"|tee $kubeadmjoinlog
ssh $slave2 "$joincmd"|tee $kubeadmjoinlog 

echo "-- installing mizar --"
mizarlog=/tmp/mizar.out
kubectl create -f mizar.dev.yaml|tee mizarlog

