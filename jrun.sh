#!/usr/bin/env bash
# run jupyter lab

# 1. get external ip
EXTERNAL_IP=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")

# 2. run jupyter lab + "Enter"
echo "" | jupyter lab --ip='0.0.0.0' --no-browser &

# 3. make url 
# warning. without sleep 1, below command will run before #2
sleep 1
JUPYTER_TOKEN=$(jupyter notebook list --json | jq -r '.token')
GET_TOKEN=$(echo ${#JUPYTER_TOKEN})
JUPYTER_URL="Click to launch http://${EXTERNAL_IP}:8888/?token=${JUPYTER_TOKEN}"

# 4. display url
echo "---------------------------------------------------------------------------"
echo ${JUPYTER_URL} 