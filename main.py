from LED_PCF8574T import update_led_states
from DHT11 import read_dht
import paho.mqtt.client as mqtt
import time

MQTT_broker = 'localhost'
MQTT_port = 1883

topic_LED = 'LED/control'
topic_temp_DHT11 = 'DHT11/temp'
topic_humid_DHT11 = 'DHT11/humid'

def on_connect_subscribe(client, userdata, flags, rc):
    print("Terhubung ke MQTT dengan code: " + str(rc))
    for i in range(8):
        client.subscribe(topic_LED + f'/{i+1}')

def on_message(client, userdata, msg):
    print(f'Message diterima: {msg.topic} {msg.payload.decode()}')
    try:
        led_index = int(msg.topic.split('/')[-1]) - 1  # Extract LED index from the topic
        led_state = msg.payload.decode().lower() == '1'  # True or False based on MQTT payload ('1' or '0')
        update_led_states(led_index, led_state)  # Update the LED state
    except (IndexError, ValueError) as e:
        print(f'Error processing message: {e}')

def publish_dht11(client):
    temp, humid = read_dht()
    if temp is not None and humid is not None:
        client.publish(topic_temp_DHT11, str(temp))
        client.publish(topic_humid_DHT11, str(humid))
        print('Publish Temp: ' + str(temp) + ' Humid: ' + str(humid))

client = mqtt.Client()
client.on_connect = on_connect_subscribe
client.on_message = on_message
client.connect(MQTT_broker, MQTT_port)

client.loop_start()


while True:
    try:
        publish_dht11(client)
        time.sleep(1) 
    except:
        print('DHT tidak terbaca')
        # client.loop_stop()
        # client.disconnect()
        client.reconnect()
        time.sleep(1)