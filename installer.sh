#!/bin/bash

CYAN='\e[36m'
YELLOW='\e[33m'
NC='\e[0m'

USERNAME=$(whoami)
HOMEPATH=$(eval echo ~$USERNAME)

echo "${CYAN}>>> Installation begin... <<<${NC}"
sleep 2

echo "${CYAN}>>> Updating... <<<${NC}"
sudo apt update

echo "${CYAN}>>> Setting up machine... <<<${NC}"
chmod +x ./machine/main.py
chmod +x ./service/reverse-ssh.sh

echo "${CYAN}>>> Setting up key tunnel... <<<${NC}"
# Ensure .ssh directory exists
mkdir -p ~/.ssh

# Add the server's SSH key to known_hosts
ssh-keyscan -t rsa 13.213.41.188 >> ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts

# Set the correct permissions for the private key
chmod 700 ~/.ssh
chmod 400 ./key/AWS-Widya.pem

echo "${CYAN}>>> Installing Mosquitto... <<<${NC}"
sudo apt install -y mosquitto

echo "${CYAN}>>> Installing Node.js and npm... <<<${NC}"
sudo apt install -y nodejs
sudo apt install -y npm

echo "${CYAN}>>> Making Virtual Environment... <<<${NC}"
python3 -m venv venv
. venv/bin/activate

echo "${CYAN}>>> Installing GPIO library... <<<${NC}"
sudo apt install -y gpiod

echo "${CYAN}>>> Installing Required libraries... <<<${NC}"
pip3 install -r requirements.txt

echo "${CYAN}>>> Raspberry configuration... <<<${NC}"
sudo raspi-config nonint do_i2c 0

echo "${CYAN}>>> Installing PM2... <<<${NC}"
sudo npm install -g pm2

echo "${CYAN}>>> Setting up PM2 services... <<<${NC}"
# Start the main Python script with PM2
pm2 start ./machine/main.py --name main-script
# Start the reverse SSH tunnel service with PM2
# pm2 start -f ./service/reverse-ssh.json
# pm2 start ssh --name reverse-ssh -- -o "StrictHostKeyChecking=no" -f -N -R 5050:localhost:1883 ubuntu@13.213.41.188 -i ./key/AWS-Widya.pem
pm2 start ./service/reverse-ssh.sh --name reverse-ssh

echo "${CYAN}>>> Saving PM2 process list... <<<${NC}"
pm2 save

echo "${CYAN}>>> Configuring PM2 to run on startup... <<<${NC}"
# PM2 Startup Settings
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USERNAME --hp $HOMEPATH

echo "${CYAN}>>> Setup Firewall... <<<${NC}"
sudo apt install -y ufw=0.36-7.1
sudo ufw allow ssh

echo "${CYAN}>>> Installation Completed <<<${NC}"
echo "${YELLOW}====Now you can install Node-RED on client device and import flows.json====${NC}"
