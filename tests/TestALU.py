from ALU import ALU
from testboard import TestBoard
from time import sleep

alu = ALU()
testboard = TestBoard()

alu.connectTestBoard(testboard, 8)

alu.enableLEDs(True)


alu.A = 0xA5
alu.B = 0x5A
alu.Cin = 0

# while True:
#     alu.ADD = 0
#     sleep(0.20)
#     alu.ADD = 1
#     sleep(0.20)

doSweep = True

alu.ADD = 1
alu.XOR = 1
alu.AND = 0
alu.SUB = 0
alu.nSET0 = 0

if doSweep:
    for A in range(1 << alu.N):
        for B in range(1 << alu.N):
            alu.A = A
            alu.B = B
            print(f"A = {A}, B={B} ==> S={alu.S}")
else:
    alu.A = 0x5A
    alu.B = 0x33