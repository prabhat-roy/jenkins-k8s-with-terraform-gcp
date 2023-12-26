#set hostname
sudo hostnamectl set-hostname wazuh
#update
sudo apt-get update -y
#install wazuh
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
