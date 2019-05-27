# ygromovwork_infra
ygromovwork Infra repository

# bastion - one line command to connect to internal hosts at GCP project
ssh -A -tt 35.228.166.42 ssh -tt 10.166.0.3

# second option connect directly to internal GCP network
# create and add the folloing to .ssh/config
Host GCP_INTERNAL_SUBNET.*
  ProxyJump EXTERNAL_IP_OF_PROXY_HOST:22

# bastion openVPN
bastion_IP = 35.228.166.42
someinternalhost_IP = 10.166.0.3

# homework #4
testapp_IP = 35.228.90.31
testapp_port = 9292

# automated instance and app deploy
gcloud compute instances create reddit-app \
--boot-disk-size=10GB  \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--metadata-from-file startup-script=startUp.sh

# add firewall rule
gcloud compute firewall-rules create default-puma-server1 \
    --network default \
    --action allow \
    --direction ingress \
    --rules tcp:9292 \
    --source-ranges 0.0.0.0/0 \
    --target-tags puma-server
