import adafruit_dht
import board

sensor = adafruit_dht.DHT11(board.D4, use_pulseio = False)


def read_dht():
    temp = sensor.temperature
    humid = sensor.humidity
    if temp is not None and humid is not None:
        return temp, humid
    else:
        print("Pembacaan data DHT11 gagal")
        return None, None
    
read_dht()