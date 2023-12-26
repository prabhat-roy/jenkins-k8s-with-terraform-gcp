#change hostname
sudo hostnamectl set-hostname sonar
#update
sudo apt-get update -y
#install java 17
sudo apt-get install unzip openjdk-17-jdk -y
#install postgresql
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get -y install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
#set password
sudo echo postgres:postgres | sudo chpasswd
#configure postgresql
su - postgres
createuser sonar
psql
ALTER USER sonar WITH ENCRYPTED password 'sonar';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar; 
\q
exit
sudo useradd sonar
sudo echo sonar:sonar | sudo chpasswd
cd /opt
#downlaod sonarqube 9.1.0.47736
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip
sudo unzip sonarqube-9.1.0.47736.zip
sudo rm -rf /opt/sonarqube-9.1.0.47736.zip
sudo mv sonarqube-9.1.0.47736 sonarqube
#configure sonarqube
sudo groupadd sonar
sudo chown -R sonar:sonar /opt/sonarqube
sudo sed -i 's/#sonar.jdbc.username=/sonar.jdbc.username=sonar/' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#sonar.jdbc.password=/sonar.jdbc.password=sonar/' /opt/sonarqube/conf/sonar.properties
sudo sed -i 's/#RUN_AS_USER=/RUN_AS_USER=sonar/' /opt/sonarqube/bin/linux-x86-64/sonar.sh
cat <<EOF | sudo tee /etc/systemd/system/sonar.service
[Unit] 
Description=SonarQube service 
After=syslog.target network.target 
[Service] 
Type=forking 
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start 
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop 
User=sonar 
Group=sonar 
Restart=always 
[Install] 
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now sonar
sudo systemctl start sonar