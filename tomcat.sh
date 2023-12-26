#change hostname
sudo hostnamectl set-hostname tomcat
#updat
sudo apt-get update -y
#add tomcat user
sudo adduser tomcat --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
#set tomcat password
sudo echo tomcat:tomcat | sudo chpasswd
cd /opt
#install Java 21
sudo apt-get install openjdk-21-jdk -y
#Download and configure tomcat 11
sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.0-M15/bin/apache-tomcat-11.0.0-M15.tar.gz
sudo tar -xvzf apache-tomcat-11.0.0-M15.tar.gz
sudo mv apache-tomcat-11.0.0-M15 tomcat
sudo chown -R tomcat:tomcat /opt/tomcat
sudo rm -rf apache-tomcat-11.0.0-M15.tar.gz
sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target
[Service]
Type=forking
Restart=always
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid/"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
#start tomcat service
sudo systemctl start tomcat
sudo systemctl enable tomcat
#enable password authentication
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
#Enable root login
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#Enable public key authentication
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
#restart sshd service
sudo systemctl restart sshd
sudo systemctl restart tomcat
su tomcat
#generate a keypair of tomcat user and add private key in jenkins credentials
ssh-keygen
cd ~/.ssh
cat id_rsa.pub >> authorized_keys
cat id_rsa
exit
#update the below file for deployment by tomcat user
sudo vi /opt/tomcat/conf/tomcat-users.xml
<role rolename="manager-script"/>
    <user username="tomcat" password="tomcat" roles="manager-script"/>