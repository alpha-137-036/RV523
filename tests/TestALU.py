from ALU import ALU
from testboard import TestBoard

alu = ALU()
testboard = TestBoard()

alu.connectTestBoard(testboard, 4)

alu.enableLEDs(True)

alu.ADD = 1
alu.XOR = 1

for A in range(1 << alu.N):
    for B in range(1 << alu.N):
        alu.A = A
        alu.B = B
        print(f"A = {A}, B={B} ==> S={alu.S}")
