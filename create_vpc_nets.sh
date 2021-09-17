#!/bin/bash

set -e

# 
# verify vpc0 is already provisioned
#
vpc0=`kubectl get vpc vpc0|awk '{print $6}'`
net0=`kubectl get subnet net0|awk '{print $6}'`
while [[ "$vpc0" != *"Provisioned"* || "$net0" != *"Provisioned"* ]]
do
  echo ">> waiting 5 seconds for vpc0 to be provisioned"
  sleep 5 
  vpc0=`kubectl get vpc vpc0|awk '{print $6}'`
  net0=`kubectl get subnet net0|awk '{print $6}'`
done

#
# clean up old files
#
rm -f net1.yaml net2.yaml

#
# create vpc and wait till VNI is populated
#

kubectl create -f ./test_vpc1.yaml

vni=""
while [ -z "$vni" ]
do
  echo ">> wait for VNI from vpc1"
  sleep 1
  vni=$(kubectl get vpc vpc1|grep vpc1|awk '{print $4}')
done
sleep 5 

#
# replace with the right VNI
#
echo ">> setting VNI to $vni for subnets"
cat test_net1.yaml.template|sed "s/VPC_VNI/$vni/" > net1.yaml 
#cat test_net2.yaml.template|sed "s/VPC_VNI/$vni/" > net2.yaml 

#
# create subnets
#
kubectl create -f ./net1.yaml 
#kubectl create -f ./net2.yaml 
