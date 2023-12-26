#change hostname
sudo hostnamectl set-hostname jenkins-agent
#update
sudo apt-get update -y
#Install required packages
sudo apt-get install git unzip curl -y
#Download and install Trivy
wget https://github.com/aquasecurity/trivy/releases/download/v0.48.1/trivy_0.48.1_Linux-64bit.deb
sudo dpkg -i trivy_0.48.1_Linux-64bit.deb
#Install Anchore Syft
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
#Install Anchore Grype
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
#Install Ansible
sudo apt-get -y install ansible
#Install Java 21
sudo apt-get install openjdk-21-jdk -y
cd /opt
#Download and configure Apache Maven 3.9.6
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.6-bin.tar.gz
sudo rm -rf apache-maven-3.9.6-bin.tar.gz
export PATH=$PATH:/opt/apache-maven-3.9.6/bin
#Download and configure Apache Gradle 8.5
sudo wget https://services.gradle.org/distributions/gradle-8.5-bin.zip
sudo unzip gradle-8.5-bin.zip
export PATH=$PATH:/opt/gradle-8.5/bin
sudo rm -rf unzip gradle-8.5-bin.zip
#Download and configure Apache Ant 1.10.14
sudo wget https://dlcdn.apache.org//ant/binaries/apache-ant-1.10.14-bin.zip
sudo unzip apache-ant-1.10.14-bin.zip
sudo rm -rf apache-ant-1.10.14-bin.zip
cat <<EOF | sudo tee /etc/profile.d/ant.sh
ANT_HOME=/opt/apache-ant-1.10.14
PATH=$ANT_HOME/bin:$PATH
EOF
#Install docker
sudo apt-get install docker.io -y
sudo chmod 777 /var/run/docker.sock
sudo systemctl start docker
sudo systemctl enable docker
#Update nexus details
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "insecure-registries" : ["nexus-private-ip:port"]
}
EOF
#Restart docker
sudo systemctl restart docker
#Install Kubectl
sudo curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
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
#dockerhub login to download and install docker scout
docker login -u prabhatrkumaroy -p dckr_pat_adACRUhmUW9rCIpglNpnKhQ2hUg
curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh
sh install-scout.sh
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