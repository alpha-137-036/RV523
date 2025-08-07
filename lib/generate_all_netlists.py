import pyjson5 as json5
import subprocess

with open("cellList.json5") as f:
    cellList = json5.decode(f.read())

RV523_behavioral = ""

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
    try:
        with open(cellName + "/" + cellName + "_behavioral.v", "r") as f:
            RV523_behavioral += f.read().strip() + "\n\n"
    except IOError:
        print(f"Warning: {cellName}_behavioral.v is missing")

print(f"Writing RV523_behavioral.v")
with open("RV523_behavioral.v", "w") as text_file:
    text_file.write(RV523_behavioral)
