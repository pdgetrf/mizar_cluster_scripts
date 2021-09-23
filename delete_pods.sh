#!/bin/bash

kubectl delete -f vanilla.yaml &
kubectl delete -f vanilla-net1.yaml &
kubectl delete -f vanilla-net2.yaml &
