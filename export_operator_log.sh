#!/bin/bash

kubectl logs $(kubectl get pods|grep operator|awk '{print $1}')
