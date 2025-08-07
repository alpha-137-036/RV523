import pyjson5 as json5
import subprocess

with open("cellList.json5") as f:
    cellList = json5.decode(f.read())

for cellName in cellList:
    print(f"================================= {cellName}")
    yosysScript = f"""
        read_verilog -sv {cellName}.v ../RV523_MOSFETS.v
        prep -top {cellName}
        flatten
        write_json {cellName}.net.json
        exec -- python3 ../../tools/yosysJsonToKicadNetlist.py {cellName}.net.json {cellName}.net --spice {cellName}.ckt        
    """
    subprocess.run(cwd=cellName, args=[
        "yosys", 
        "-p",
        yosysScript
    ])
