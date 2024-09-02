echo '>>> Instalation begin... <<<'
sleep 2
echo '>>> Installing Mosquitto <<<'
sudo apt install -y mosquitto

echo '>>> Making Virtual Environtment <<<'
python -m venv venv_LED_DHT11
source venv_LED_DHT11/activate

echo '>>> Installing Required libraries <<<'
pip install -r requirements.txt

echo '>>> Raspberry configurations <<<'
sudo raspi-config nonint do_i2c 0

echo '>>> Setup Firewall <<<'
sudo apt install -y ufw=0.36-7.1
sudo ufw allow ssh

echo '>>> Setup reverse SSH tunnel <<<'
ssh -f -N -R 5050:localhost:1883 ubuntu@13.213.41.188 -i AWS-Widya.pem 

echo '>>> Run main.py <<<'
python3 main.py

echo '>>> Installation Finished <<<'
echo 'Now you can install Node-RED on client device and import flows.json'