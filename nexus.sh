#change hostname
sudo hostnamectl set-hostname nexus
#update
sudo apt-get update -y
#install inzip
sudo apt-get install unzip -y
#install java 8
sudo apt-get install openjdk-8-jdk -y
cd /opt
#download Nexus 3.63.0.01
sudo wget -O nexus-3.63.0-01-unix.tar.gz https://download.sonatype.com/nexus/3/nexus-3.63.0-01-unix.tar.gz
sudo tar -xvzf nexus-3.63.0-01-unix.tar.gz
sudo rm -rf /opt/nexus-3.63.0-01-unix.tar.gz
#add nexus user
sudo useradd nexus
sudo echo nexus:nexus | sudo chpasswd
#set permission
sudo chown -R nexus:nexus nexus-3.63.0-01/
sudo chown -R nexus:nexus sonatype-work/
#update the below file
cat <<EOF | sudo tee /opt/nexus-3.63.0-01/bin/nexus.rc
run_as_user="nexus"
EOF
cat <<EOF | sudo tee /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/nexus-3.63.0-01/bin/nexus start
ExecStop=/opt/nexus-3.63.0-01/bin/nexus stop
User=nexus
Group=nexus
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nexus.service
#start nexus service
sudo systemctl start nexus.service
#get admin password. This will work after few mins
sudo cat /opt/sonatype-work/nexus3/admin.password