import smbus2

PCF_address = 0x20

bus = smbus2.SMBus(1)

led_states = [0]*8

def set_leds():
    byte_value = 0
    for i in range (8):
        if led_states[i]:
            byte_value |= (1<<i)
    bus.write_byte(PCF_address, byte_value)

def update_led_states(led_index,state):
    led_states[led_index] = state
    set_leds()

