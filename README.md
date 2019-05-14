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
