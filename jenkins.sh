#Update hostname
sudo hostnamectl set-hostname jenkins
#update system
sudo apt-get update -y
#Install Java 21
sudo apt-get install openjdk-21-jdk -y
#Download and install jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl daemon-reload
#start jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
#get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
