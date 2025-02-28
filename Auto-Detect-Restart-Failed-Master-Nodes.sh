#!/bin/bash

# Get list of master nodes
MASTER_NODES=$(oc get nodes -l node-role.kubernetes.io/master -o jsonpath='{.items[*].metadata.name}')

for NODE in $MASTER_NODES; do
  STATUS=$(oc get node $NODE -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
  if [ "$STATUS" != "True" ]; then
    echo "Master node $NODE is down. Attempting to restart..."
    ssh root@$NODE "reboot"
  else
    echo "Master node $NODE is healthy."
  fi
done
