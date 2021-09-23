#!/bin/bash

to=`kubectl get pods -o wide|grep pod-in-net2|awk '{print $6}'`
from=`kubectl get pods -o wide|grep pod-in-net1|awk '{print $6}'`
echo "pinging $to from $from" 
kubectl exec -it pod-in-net1 -- /bin/ping $to
