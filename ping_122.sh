#!/bin/bash

set -e

# this pings the pod in the .122 subnet from the pod in the .0 subnet

to=`kubectl get pods -o wide|grep pod-in-net2|awk '{print $6}'`
from=`kubectl get pods -o wide|grep pod-in-net1|awk '{print $6}'`
echo "-------"
echo "pinging $to from $from" 
echo "-------"
kubectl exec -it pod-in-net1 -- /bin/ping $to
