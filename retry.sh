#!/bin/bash

TPU_NAME=$1

ACCELERATOR="v3-32"
ZONE="europe-west4-a"
TF_VERSION="nightly"
# Modify this for poll rate (in seconds).
POLLING_FREQUENCY=30

while True
do
  export TERMINATED=$(gcloud compute tpus describe $TPU_NAME | grep "health: terminated")
  export UNHEALTHY=$(gcloud compute tpus describe $TPU_NAME | grep "health: unhealthy_maintenance")
  if [ -z $TERMINATED] | [ -z $UNHEALTHY]; then
    echo "TPU is in an unhealthy state, restarting the node."
    gcloud compute tpus delete $TPU_NAME
    gcloud compute tpus execution-groups create \
       --tpu-only \
       --reserved \
       --accelerator-type=$ACCELERATOR \
       --name=$TPU_NAME \
       --zone=$ZONE \
       --tf-version=$TF_VERSION
  else
    echo "TPU is healthy."
  fi

  sleep $POLLING_FREQUENCY
done
