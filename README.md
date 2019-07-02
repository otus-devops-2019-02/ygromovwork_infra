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

# ДЗ №5
create image with packer @GCP for immutable app deploy
~]$ packer build -var-file=variables.json immutable.json
start VM @GCP
~]$ config-scripts/create-reddit-vm.sh


# ДЗ №6
created new project for deployment
1) 2 app instances main.tf
declare variables
use one resorce to create 2 app instances

2) 1 loadbalancer lb.tf
based on nginx (upstream)
has to be deployed after app instances are UP (depends_on)

3) output IPs of instances