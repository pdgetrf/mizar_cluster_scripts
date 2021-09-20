#!/bin/bash

ip=`kubectl get pods -o wide|grep pod-in-net1|awk '{print $6}'`
kubectl exec -it pod-in-net2 -- /bin/ping $ip
