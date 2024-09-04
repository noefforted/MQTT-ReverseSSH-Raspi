#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m'

echo "${CYAN}>>> Installation begin... <<<${NC}"
sleep 2

echo "${CYAN}>>> Updating... <<<${NC}"
sudo apt update

echo "${CYAN}>>> Installing Mosquitto <<<${NC}"
sudo apt install -y mosquitto

echo "${CYAN}>>> Making Virtual Environment <<<${NC}"
python -m venv venv
. venv/bin/activate

echo "${CYAN}>>> Installing GPIO library <<<${NC}"
sudo apt install -y gpiod

echo "${CYAN}>>> Installing Required libraries <<<${NC}"
pip3 install -r requirements.txt

echo "${CYAN}>>> Raspberry configuration <<<${NC}"
sudo raspi-config nonint do_i2c 0

echo "${CYAN}>>> Setup Firewall <<<${NC}"
sudo apt install -y ufw=0.36-7.1
sudo ufw allow ssh

echo "${CYAN}>>> Configuring permissions <<<${NC}"
chmod 400 AWS-Widya.pem

echo "${CYAN}>>> Setup reverse SSH tunnel <<<${NC}"
ssh -f -N -R 5050:localhost:1883 ubuntu@13.213.41.188 -i AWS-Widya.pem 

echo "${CYAN}>>> Installing Node.js and npm <<<${NC}"
sudo apt install -y nodejs

echo "${CYAN}>>> Installing PM2 <<<${NC}"
sudo npm install -g pm2

echo "${CYAN}>>> Setting up PM2 to run main.py after reboot <<<${NC}"
pm2 start python3 --name dhtled -- main.py
pm2 save
pm2 startup
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $(whoami) --hp $(eval echo ~$(whoami))

echo "${CYAN}>>> Installation Finished <<<${NC}"
echo "${CYAN}Now you can install Node-RED on client device and import flows.json${NC}"
