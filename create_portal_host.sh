#!/bin/bash

source common.lib

portalhost_filename=portal_host.properties
exitIfFileNotExist ${portalhost_filename}

portal_host_ip="$(cat ${portalhost_filename})"

# Remove the old configmap file
rm -f portal_host_configmap.yaml

# Create a new configmap file from portal)host.properties
echo "Replacing [PORTAL_HOST] with $portal_host_ip in configmap"
cat portal_host_configmap.yaml.template|sed "s/PORTAL_HOST/$portal_host_ip/" > portal_host_configmap.yaml

# Use kubectl to apply changes
kubectl apply -f ./portal_host_configmap.yaml

rm -f portal_host_configmap.yaml
