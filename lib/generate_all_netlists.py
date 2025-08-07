import pyjson5 as json5
import subprocess

with open("cellList.json5") as f:
    cellList = json5.decode(f.read())

for cellName in cellList:
    print(f"================================= {cellName}")
    subprocess.run(cwd=cellName, args=["yosys", cellName + ".ys"])
