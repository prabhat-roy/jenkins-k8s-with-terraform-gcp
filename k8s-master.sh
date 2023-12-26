#set hostname
sudo hostnamectl set-hostname master
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
#Initialize kubeadm with custom pod network
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
#access the kubernetes master
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#apply flannel plugin
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#Update nexus details
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "insecure-registries" : ["nexus-private-ip:port"]
}
EOF
#Restart docker
sudo systemctl restart docker
#Enable password authentication
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
#Enable root login
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#Enable public key authentication
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
#Restat sshd service
sudo systemctl restart sshd
#create key-pair and copy public key to authorized keys and add private key to jenkins credentials
ssh-keygen
cd ~/.ssh
cat id_rsa.pub >> authorized_keys
cat id_rsa
#login to nexus
docker login -u <username> -p <passowrd> nexus-private-ip:port
#validate the config
cat ~/.docker/config.json
#create a secret with above login to run doker images in kubernetes
kubectl create secret generic project-a --from-file=.dockerconfigjson=/root/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl get secret project-a --output=yaml
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
