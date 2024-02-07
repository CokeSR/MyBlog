#!/bin/sh
#-*-encoding:utf-8-*-
##########################################################
# author: Coke
# date: 2024/01/26
# description: you can define what you want in Define_content
##########################################################
# build blog system with helo style [Docker]

# Define_content
protainer_port=9000
protainer_path=development/Protainer

# Try to get ip addresses
outernal_ip=$(curl -s https://api.ipify.org)
get_internal_ip() {
  internal_ip=$(hostname -I | awk '{print $1}')
  echo $internal_ip
}
internal_ip=$(get_internal_ip)
echo "outer_ip: $internal_ip inner_ip: $outernal_ip"

# Install docker
sudo apt install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "docker install successful"
echo "—————————————————————————————"

# Pull & start docker portainer
mkdir -p /$protainer_path
docker pull portainer/portainer-ce
docker run -d -p $protainer_port:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /$protainer_path:/data --restart=always --name portainer portainer/portainer-ce:latest

# echo
echo "________________________________________"
echo "Running status："
docker ps
echo "————————————————————————————————————————"
echo "View docker web manager:"
echo "inner_ip: $internal_ip:$protainer_port"
echo "outer_ip: $outernal_ip:$protainer_port"
echo "————————————————————————————————————————"
echo "Halo web manager："
echo "inner_ip: $internal_ip:$halo_port"
echo "outer_ip: $outernal_ip:$halo_outer_port"
echo "————————————————————————————————————————"
echo "Mysql config："
echo "password：$mysql_password"
echo "port：$mysql_connection_port"
echo "————————————————————————————————————————"
echo "please into Halo-Blog folder"
echo "run 'docker compose up -d && docker compose logs -f' to continue"
