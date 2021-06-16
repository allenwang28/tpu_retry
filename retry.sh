#!/bin/bash

TPU_NAME=$1

ACCELERATOR="v2-8"
ZONE="europe-west4-a"
TF_VERSION="nightly"
# Modify this for poll rate (in seconds).
POLLING_FREQUENCY=30

while True
do
  export TERMINATED=$(gcloud compute tpus describe --zone=$ZONE $TPU_NAME | grep "state: TERMINATED")
  export UNHEALTHY=$(gcloud compute tpus describe --zone=$ZONE $TPU_NAME | grep "health: UNHEALTHY_MAINTENANCE")
  if !( [ -z "$TERMINATED" ] | [ -z "$UNHEALTHY" ] ); then
    echo "TPU is in an unhealthy state, restarting the node."
    gcloud compute tpus delete $TPU_NAME --zone=$ZONE --quiet
    gcloud compute tpus create --quiet \
      --accelerator-type=$ACCELERATOR \
      --zone=$ZONE \
      --version=$TF_VERSION \
      $TPU_NAME

  else
    echo "TPU is healthy."
  fi

  sleep $POLLING_FREQUENCY
done
