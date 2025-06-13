import board
import busio

# Virtual I2C bus automatically selecting TCA channel
# Each TCA channel is assumed to have a testboard with up to 8 MCP23017 chips with local addresses 0x20-0x27
# In the virtual I2C bus, all these chips appear with the following addresses:
# Channel #0: 0x20-0x27
# Channel #1: 0x28-0x2F
# ...
# Channel #7: 0x58-0x5F

class VirtualI2C:
    def __init__(self, scl, sda):
        self.init(scl, sda)
    def init(self, scl, sda):
        self._i2c = busio.I2C(board.SCL, board.SDA)
        self._channel = -1
    def _select_channel(self, channel):
        if channel != self._channel:
            self._i2c.writeto(0x70, bytearray([1 << channel]))
            self._channel = channel
    def _select_address(self, address):
        if address >= 0x20 and address < 0x60:
            self._select_channel((address - 0x20) >> 3)
            return 0x20 + (address & 0x7)
        else:
            raise OSError("Invalid address " + address)
    def scan(self):
        slaves = []
        for channel in range(8):
            self._select_channel(channel)
            slaves.extend([channel * 8 + address for address in self._i2c.scan() if address != 0x70])
        return slaves
    def probe(self, address):
        # for some reason, i2c.probe doesn't work?
        try:
            address = self._select_address(address)
            self._i2c.writeto(address, b"")
            return True
        except OSError:
            return False
    def writeto(self, address,  buffer, *, start = 0,end=None):
        address = self._select_address(address)
        self._i2c.writeto(address, buffer, start=start, end=end)
    def readfrom_into(self, address, buffer, *, start=0, end=None):
        address = self._select_address(address)
        return self._i2c.readfrom_into(address, buffer, start=start, end=end)
    def writeto_then_readfrom(
        self,
        address,
        buffer_out,
        buffer_in,
        *,
        out_start=0,
        out_end=None,
        in_start=0,
        in_end=None,
        stop=False,
    ):        
        address = self._select_address(address)
        return self._i2c.writeto_then_readfrom(address, buffer_out, buffer_in, 
                                               out_start=out_start, out_end=out_end, in_start=in_start, in_end=in_end, stop=stop)
    def try_lock(self):
        return self._i2c.try_lock()
    def unlock(self):
        self._i2c.unlock()
        