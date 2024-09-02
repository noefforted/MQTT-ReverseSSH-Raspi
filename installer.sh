CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo "${CYAN}>>> Installation begin... <<<${NC}"
sleep 2

echo "${CYAN}>>> Installing Mosquitto <<<${NC}"
sudo apt install -y mosquitto

echo "${CYAN}>>> Making Virtual Environment <<<${NC}"
python -m venv venv_LED_DHT11
source venv_LED_DHT11/bin/activate

echo "${CYAN}>>> Installing Required libraries <<<${NC}"
pip install -r requirements.txt

echo "${CYAN}>>> Raspberry configurations <<<${NC}"
sudo raspi-config nonint do_i2c 0

echo "${CYAN}>>> Setup Firewall <<<${NC}"
sudo apt install -y ufw=0.36-7.1
sudo ufw allow ssh

echo "${CYAN}>>> Setup reverse SSH tunnel <<<${NC}"
ssh -f -N -R 5050:localhost:1883 ubuntu@13.213.41.188 -i AWS-Widya.pem 

echo "${CYAN}>>> Run main.py <<<${NC}"
python3 main.py

echo "${CYAN}>>> Installation Finished <<<${NC}"
echo "${CYAN}Now you can install Node-RED on client device and import flows.json${NC}"
