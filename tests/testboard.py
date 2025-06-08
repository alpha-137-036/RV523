import time
import board
import busio
from digitalio import Direction
from adafruit_mcp230xx.mcp23017 import MCP23017
i2c = busio.I2C(board.SCL, board.SDA)


class TestBoard:
    mcp = []
    def __init__(self):
        for i in range(5):
            self.mcp.append(MCP23017(i2c, address=32+i))

    def get_pin(self, i):
        return self.mcp[i >> 4].get_pin(i % 16)
    
    # Get a pin and configure it as output with the specified initial value
    def get_output_pin(self, i, init):
        pin = self.get_pin(i)
        pin.direction = Direction.OUTPUT
        pin.value = init
        return pin

    # Get a pin and configure it as input 
    def get_input_pin(self, i):
        pin = self.get_pin(i)
        pin.direction = Direction.INPUT
        return pin
