#!/usr/bin/env bash
# install and prepare to run jupyter lab

# 1. get auth
gcloud auth login

# 2. make firewall rule
# name: allow-8888
# port: tcp:8888
gcloud compute firewall-rules create allow-8888 \
        --allow tcp:8888 \
        --target-tags allow-8888 

# 3. get zone and external ip of compute instance for conviniance
ZONE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google")
ZONE=${ZONE##*/}
EXTERNAL_IP=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google")

# 4. allow firewall rules to compute instance
# warning. use comma between firewall rules name. no space allowed
# warning. use "" to variables ${HOSTNAME} and ${ZONE}
gcloud compute instances add-tags "${HOSTNAME}" \
        --zone="${ZONE}" \
        --tags allow-8888,http-server,https-server  

# 5. install packages
sudo apt-get update
sudo apt-get install python-pip -y
sudo pip install jupyterlab
sudo apt-get install jq -y

# 5. run jupyter lab
# warning. echo "" and pipe (|) gives enter to jupyter lab
# so script can keep process
echo "" | jupyter lab --ip='0.0.0.0' --no-browser &

# 6. make url 
# warning. without sleep 1, below command will run before #5
sleep 1
JUPYTER_TOKEN=$(jupyter notebook list --json | jq -r '.token')
GET_TOKEN=$(echo ${#JUPYTER_TOKEN})
JUPYTER_URL="Click to launch http://${EXTERNAL_IP}:8888/?token=${JUPYTER_TOKEN}"

# 7. display URL
echo "---------------------------------------------------------------------------"
echo ${JUPYTER_URL} 