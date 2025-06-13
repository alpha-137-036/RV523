import board
import busio
from digitalio import Direction, DriveMode
from adafruit_mcp230xx.mcp23017 import MCP23017
from TCA9548_VirtualI2C import VirtualI2C

i2c = VirtualI2C(board.SCL, board.SDA)

class TestBoard:
    mcp = []
    def __init__(self):
        for i in range(64):
            mcp = None
            if (i2c.probe(0x20 + i)):
                mcp = MCP23017(i2c, address=0x20 + i)
            self.mcp.append(mcp)

    def get_pin(self, i):
        return self.mcp[i >> 4].get_pin(i & 0xF)
    
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
    
    def get_opendrain_pin(self, i):
        pin = self.get_pin(i)
        pin.value = 1
        pin.drive_mode = DriveMode.OPEN_DRAIN
        pin.direction = Direction.OUTPUT
        return pin