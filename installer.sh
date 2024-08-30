echo '>>> Instalation begin... <<<'

echo '>>> Installing Mosquitto <<<'
sudo apt install mosquitto

echo '>>> Making Virtual Environtment <<<'
python -m venv venv_LED_DHT11
source venv_LED_DHT11/activate

echo '>>> Installing Required libraries <<<'
pip install -r requirements.txt

