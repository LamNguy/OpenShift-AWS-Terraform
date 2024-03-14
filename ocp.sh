#!/bin/bash
#Maintainer DineshReddy Kayithi kdinesh.in
OPENSHIFT_VERSION=4.14                         # Enter OpenShift Version -4.12/4.13/4.14
BASE_DOMAIN=svtech.gay                      # Enter Base Domain Name 
CLUSTER_NAME=ocp4                            # Cluster Name
AWS_REGION=ap-southeast-1                             # Enter AWS Region name ,In which region you want to deploy 
AWS_ZONE1=ap-southeast-1a                            # Enter AWS Zone name        
AWS_ZONE2=ap-southeast-1b                             # Enter AWS Zone2 name
CONREOLPLANE_NODE_FLAVOR=m6i.xlarge
WORKER_NODE_FLAVOR=m6i.xlarge
NUMBER_OF_WORKER_NODES=3                          # Number of Worker Nodes
NETWORK_TYPE=OVNKubernetes                        # OVNKubenetes or openshiftSDN
CLUSTER_NETWORK_CIDR=10.128.0.0/14
MACHINE_NETWORK_CIDR=10.0.0.0/16
SERVICE_NETWORK_CIDR=172.30.0.0/16
PULLSECRET_KEY=eyJhdXRocyI6eyJjbG91ZC5vcGVuc2hpZnQuY29tIjp7ImF1dGgiOiJiM0JsYm5Ob2FXWjBMWEpsYkdWaGMyVXRaR1YySzI5amJWOWhZMk5sYzNOZlpqTXhOelUzTlRobFpXRXhOR0ZrWmpsbU5qbGxPVGxsWW1SaU5XVTVPVEE2U0Vnd1RVNUxSVGxLUXpsR1JEZFNNalpPVTBkVFdsSlVUazR3TURSS05UTkdXVlZUT1VnMk9FZ3pNa3BDV1VReFJrRXpWVTFLVjFSVlRFVktVVFpTV1E9PSIsImVtYWlsIjoibGFtLm5kQHN2dGVjaC5jb20udm4ifSwicXVheS5pbyI6eyJhdXRoIjoiYjNCbGJuTm9hV1owTFhKbGJHVmhjMlV0WkdWMksyOWpiVjloWTJObGMzTmZaak14TnpVM05UaGxaV0V4TkdGa1pqbG1OamxsT1RsbFltUmlOV1U1T1RBNlNFZ3dUVTVMUlRsS1F6bEdSRGRTTWpaT1UwZFRXbEpVVGs0d01EUktOVE5HV1ZWVE9VZzJPRWd6TWtwQ1dVUXhSa0V6VlUxS1YxUlZURVZLVVRaU1dRPT0iLCJlbWFpbCI6ImxhbS5uZEBzdnRlY2guY29tLnZuIn0sInJlZ2lzdHJ5LmNvbm5lY3QucmVkaGF0LmNvbSI6eyJhdXRoIjoiZkhWb1l5MXdiMjlzTFRJNVltUXlNV0ZqTFdJd05UVXRORFZqTWkxaVltRXhMVE5pTVdFeFlUVXpaV1F3T0RwbGVVcG9Za2RqYVU5cFNsTlZlbFY0VFdsS09TNWxlVXA2WkZkSmFVOXBTbWxOVkdjeFRWZEpNVTFFVlRGWmVra3dXVmRPYlZscVRUVk5SR2hyV2tSQmVFNXFRVFJhYlVwb1dtbEtPUzVxVDBwclkzQlJaVTlzY0VORWNEWTJjRXB2Y1hnMlFVdGpOV2hrUTJsT1VpMUJjM0ZwWmpoT1dsWjVPRkpWZUhaaE1YbEpOVEZTUzBwQk9GcGpaRVJVY21oRVowMDJaREIxVEVWd1JpMXNhMk5DU1ZORWRGZFBWRUU1WW5jNGFXaHZjbUV0WkV3M00yWlNNR3RtVkdNNGFFZ3paa3huU1ZWNmMyc3dialEzTVROamFFSkZPSE5vVW5SSVZrdElMVGhOYUZaalNXNDBOWEZUY1ROSlgxUk9MVU5aYVdkVGVFWk5kM2wxZUhoNVVIaHJjMHRSYjJoVlltazBYMVV5UVhCaWJVSTJOR2d4YWtWNWQxUXdSbUo0VGpGbE1rSk9iQzFmZEU1eVZVY3hUSE56ZEZaTFlqUnJPVGQ0TUUxZlNubDJXRWRMVms4dFRVUjRZalppWlVSNlkwa3hibk5HTkRWMU5VOW1SbkprZW5CNVNHNDRRbmsxTmpWSGJTMVJRakpsV2t3M1QySTNOR1ZtVjBWdVNqSXpkMGg1VDI1aU9HbFBMVlJTY0hOUE4wMVBlRTFUZFcxbFFtcFBWRWhFVG1KRmFYRlRaSG8zVm14b2EyaFZjRGgzZDNObE5rbGhSSFIzT0dNMlptNUdhRzlCTTB4Mk9WWndiemM0WjIxR05UWlhRV1Z2VVVrd2NHaHlMWEUzY25aVldrUmtVVW8wZFU5NVVWWXdSSGcxZFU5YVNrTjJaMUJDWTA5bldGbExWRlZOTW1sNmRGbE5UMlJFVmxocFYycHhiR0pHWjBSTVdUTkRObVJHWlRSTVJtUnhWMHBmYUVNNE9EUTFWMnhSUm5oaWRtMUlhVGRwU2tVeFVFMVNVSFYwYmxwalMyNDVObGhqTUdJMlRWQXRkMFpzTnpBNGFuQlVlWEJhTVhwMVYxSkVVRVJ3Tm1Sck1rVjRjalZDZDFGbVRXNDFObTl6ZDFKc2JraHlhVE5hUmpSbE9HUnlXWHBYU2w5M2FHRTBWVGhHU0ZOMGVHMDRRVGhDVFcxV1ZYaHRkV2RDTVRaaFEwNU5PRFF5Wm1oWlVYRlJhVkJMZUVKRmFtMXZYMFY0UWkxWE5tTlJkbTloYmt4Vk9UWlFZMDQ1V2tsamNHMTZRalkxVWtOVlVWRTRNa3ByVURGakxUaFFWbE5GTW10ek0wTm1WVUpVWVdZd09XUkhidz09IiwiZW1haWwiOiJsYW0ubmRAc3Z0ZWNoLmNvbS52biJ9LCJyZWdpc3RyeS5yZWRoYXQuaW8iOnsiYXV0aCI6ImZIVm9ZeTF3YjI5c0xUSTVZbVF5TVdGakxXSXdOVFV0TkRWak1pMWlZbUV4TFROaU1XRXhZVFV6WldRd09EcGxlVXBvWWtkamFVOXBTbE5WZWxWNFRXbEtPUzVsZVVwNlpGZEphVTlwU21sTlZHY3hUVmRKTVUxRVZURlpla2t3V1ZkT2JWbHFUVFZOUkdocldrUkJlRTVxUVRSYWJVcG9XbWxLT1M1cVQwcHJZM0JSWlU5c2NFTkVjRFkyY0VwdmNYZzJRVXRqTldoa1EybE9VaTFCYzNGcFpqaE9XbFo1T0ZKVmVIWmhNWGxKTlRGU1MwcEJPRnBqWkVSVWNtaEVaMDAyWkRCMVRFVndSaTFzYTJOQ1NWTkVkRmRQVkVFNVluYzRhV2h2Y21FdFpFdzNNMlpTTUd0bVZHTTRhRWd6Wmt4blNWVjZjMnN3YmpRM01UTmphRUpGT0hOb1VuUklWa3RJTFRoTmFGWmpTVzQwTlhGVGNUTkpYMVJPTFVOWmFXZFRlRVpOZDNsMWVIaDVVSGhyYzB0UmIyaFZZbWswWDFVeVFYQmliVUkyTkdneGFrVjVkMVF3Um1KNFRqRmxNa0pPYkMxZmRFNXlWVWN4VEhOemRGWkxZalJyT1RkNE1FMWZTbmwyV0VkTFZrOHRUVVI0WWpaaVpVUjZZMGt4Ym5OR05EVjFOVTltUm5Ka2VuQjVTRzQ0UW5rMU5qVkhiUzFSUWpKbFdrdzNUMkkzTkdWbVYwVnVTakl6ZDBoNVQyNWlPR2xQTFZSU2NITlBOMDFQZUUxVGRXMWxRbXBQVkVoRVRtSkZhWEZUWkhvM1ZteG9hMmhWY0RoM2QzTmxOa2xoUkhSM09HTTJabTVHYUc5Qk0weDJPVlp3YnpjNFoyMUdOVFpYUVdWdlVVa3djR2h5TFhFM2NuWlZXa1JrVVVvMGRVOTVVVll3UkhnMWRVOWFTa04yWjFCQ1kwOW5XRmxMVkZWTk1tbDZkRmxOVDJSRVZsaHBWMnB4YkdKR1owUk1XVE5ETm1SR1pUUk1SbVJ4VjBwZmFFTTRPRFExVjJ4UlJuaGlkbTFJYVRkcFNrVXhVRTFTVUhWMGJscGpTMjQ1Tmxoak1HSTJUVkF0ZDBac056QTRhbkJVZVhCYU1YcDFWMUpFVUVSd05tUnJNa1Y0Y2pWQ2QxRm1UVzQxTm05emQxSnNia2h5YVROYVJqUmxPR1J5V1hwWFNsOTNhR0UwVlRoR1NGTjBlRzA0UVRoQ1RXMVdWWGh0ZFdkQ01UWmhRMDVOT0RReVptaFpVWEZSYVZCTGVFSkZhbTF2WDBWNFFpMVhObU5SZG05aGJreFZPVFpRWTA0NVdrbGpjRzE2UWpZMVVrTlZVVkU0TWtwclVERmpMVGhRVmxORk1tdHpNME5tVlVKVVlXWXdPV1JIYnc9PSIsImVtYWlsIjoibGFtLm5kQHN2dGVjaC5jb20udm4ifX19                 # Convert and paste pullsecret key in base64 Format 
AWS_ACCESS_KEY_DATA=QUtJQVNOMkZMQ1lLNUQ0T0k0RE0K                                   # Convert and paste AWS ACCESS  key in base64 Format
AWS_SECRET_ACCESSKEY_DATA=L3BHc0Zid29DL2ZHYzR4aFZUcHI4bTg5Z3FGTHdUUzFxWkdhVFN4UQo=                             # Convert and paste AWS SECRET  key in base64 Format 

#OpenShift Deployment Configuration 

ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
apt install curl unzip -y 
curl "https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-$OPENSHIFT_VERSION/openshift-install-linux.tar.gz" | tar xz -C /tmp
mv /tmp/openshift-install /usr/bin
curl "https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-$OPENSHIFT_VERSION/openshift-client-linux.tar.gz" | tar xz -C /tmp
mv /tmp/oc /usr/bin
mv /tmp/kubectl /usr/bin
mkdir -p /ocp
cd /ocp/
SSH_KEY_DATA=$( cat /root/.ssh/id_ed25519.pub )
SSH_KEY=$(echo $SSH_KEY_DATA | awk -F '"' '{print $1}')
PULLSECRET=$(echo $PULLSECRET_KEY | awk -F '"' '{print $1}' | base64 --decode )
AWS_ACCESS_KEY=$(echo $AWS_ACCESS_KEY_DATA | awk -F '"' '{print $1}' | base64 --decode )
AWS_SECRET_ACCESSKEY=$(echo $AWS_SECRET_ACCESSKEY_DATA | awk -F '"' '{print $1}' | base64 --decode )
mkdir ~/.aws
cat<< EOF > ~/.aws/credentials
[default] 
aws_access_key_id= $AWS_ACCESS_KEY
aws_secret_access_key=$AWS_SECRET_ACCESSKEY
EOF

cat << EOF > install-config.yaml
apiVersion: v1
baseDomain: $BASE_DOMAIN
controlPlane:
  hyperthreading: Enabled
  name: master
  platform:
    aws:
      zones:
      - $AWS_ZONE1
      - $AWS_ZONE2
      rootVolume:
        iops: 4000
        size: 100
        type: io1
      type: $CONREOLPLANE_NODE_FLAVOR
  replicas: 3
compute:
- hyperthreading: Enabled
  name: worker
  platform:
    aws:
      rootVolume:
        iops: 2000
        size: 100
        type: io1
      type: $WORKER_NODE_FLAVOR
      zones:
      - $AWS_ZONE1
      - $AWS_ZONE2
  replicas: $NUMBER_OF_WORKER_NODES
metadata:
  name: $CLUSTER_NAME
networking:
  clusterNetwork:
  - cidr: $CLUSTER_NETWORK_CIDR
    hostPrefix: 23
  machineNetwork:
  - cidr: $MACHINE_NETWORK_CIDR
  networkType: $NETWORK_TYPE
  serviceNetwork:
  - $SERVICE_NETWORK_CIDR
platform:
  aws:
    region: $AWS_REGION
    hostedZone: ${route53_zone_id}
    subnets:
    - ${aws_subnet_private_a}
    - ${aws_subnet_private_b}
    - ${aws_subnet_public_a}
    - ${aws_subnet_public_b}
    

fips: false
sshKey: $SSH_KEY
pullSecret: '$PULLSECRET'
EOF
sudo openshift-install create cluster --log-level=info


