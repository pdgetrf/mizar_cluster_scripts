#!/bin/bash

kubectl delete -f vanilla.yaml --grace-period 0 &
kubectl delete -f vanilla-net1.yaml --grace-period 0 &
kubectl delete -f vanilla-net2.yaml --grace-period 0 &
