import pyjson5 as json5
import subprocess
import re

with open("cellList.json5") as f:
    cellList = json5.decode(f.read())

RV523_behavioral = ""
RV523_blackbox = ""

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
            cell_behavioral = f.read().strip()
            RV523_behavioral += cell_behavioral + "\n\n"
            try:
                module_declaration = re.search(f"(module *{cellName}[^;]*;)", cell_behavioral).group(1)
                cell_blackbox = f"""
(* blackbox *)
(* techmap_celltype = "{cellName}" *)
(* footprint = "RV523:{cellName}" *)
{module_declaration.strip()}
endmodule

                    """
                RV523_blackbox += cell_blackbox
            except:
                print(f"Warning: {cellName}_behavioral.v has no module declaration??")
    except IOError:
        print(f"Warning: {cellName}_behavioral.v is missing")

print(f"Writing RV523_behavioral.v")
with open("RV523_behavioral.v", "w") as text_file:
    text_file.write(RV523_behavioral)

print(f"Writing RV523_blackbox.v")
with open("RV523_blackbox.v", "w") as text_file:
    text_file.write(RV523_blackbox)
