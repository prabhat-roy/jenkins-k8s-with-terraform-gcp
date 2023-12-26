#set hostname
sudo hostnamectl set-hostname worker
#update the system
sudo apt-get update -y
#install docker
sudo apt-get install -y docker.io
sudo chmod 777 /var/run/docker.sock
#download and insteall kubernetes 1.20
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=1.20.0-00 kubeadm=1.20.0-00 kubectl=1.20.0-00
#Update nexus details
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "insecure-registries" : ["nexus-private-ip:port"]
}
EOF
#Restart docker    
sudo systemctl restart docker
#Dependencies for wazuh docker monitoring
apt-get update && apt-get install python3
apt-get install python3-pip -y
pip3 install docker==4.2.0
#update the below files to get docker logs in wazuh
vi /var/ossec/etc/ossec.conf
<wodle name="docker-listener">
  <disabled>no</disabled>
</wodle>
systemctl restart wazuh-agent
