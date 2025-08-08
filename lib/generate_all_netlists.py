import pyjson5 as json5
import subprocess
import re

warnings = []
def warning(msg):
    global warnings
    warnings.append(msg)
    print(f"WARNING: {msg}")

with open("cellList.json5") as f:
    cellList = json5.decode(f.read())

RV523_behavioral = ""
RV523_blackbox = ""
RV523_lef = """
VERSION 5.7 ;
BUSBITCHARS "[]" ;
DIVIDERCHAR "/" ;

UNITS
  DATABASE MICRONS 1000 ;
END UNITS

""".strip()

def generate_cell_lef(config):
    cell_lef = f"""
MACRO {cellName}
  CLASS CORE ;
  ORIGIN 0 0 ;
  SIZE {config['width']} BY 4 ;

  SITE CoreSite ;
    """
    for pinName, pinConfig in config["pins"].items():
        direction = ""
        if pinName in config["inputs"]:
            direction = "DIRECTION INPUT ;"
        if pinName in config["outputs"]:
            direction = "DIRECTION OUTPUT ;"
        pinX = pinConfig - 0.5
        pinY = 1.75 if pinConfig % 2 == 0 else 2.25
        cell_lef += f"""
  PIN {pinName}
      {direction}
      USE SIGNAL ;
      PORT
          LAYER M1 ;
          RECT {pinX - 0.2} {pinY - 0.2} {pinX + 0.2} {pinY + 0.2} ;
      END
  END {pinName}
        """
    cell_lef += f"""
END {cellName}
"""
    return cell_lef

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
        with open(f"{cellName}/{cellName}_behavioral.v", "r") as f:
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
                warning(f"{cellName}_behavioral.v has no module declaration??")
    except IOError:
        warning(f"{cellName}_behavioral.v is missing")
    try:
        with open(f"{cellName}/{cellName}_config.json5", "r") as f:
            cell_config = json5.decode(f.read())
            RV523_lef += generate_cell_lef(cell_config)
    except IOError:
        warning(f"{cellName}.json5 is missing")

RV523_lef += """
END LIBRARY"""

print("--------------------")
for warning in warnings:
    print(f"WARNING: {warning}")

print(f"Writing RV523_behavioral.v")
with open("RV523_behavioral.v", "w") as text_file:
    text_file.write(RV523_behavioral)

print(f"Writing RV523_blackbox.v")
with open("RV523_blackbox.v", "w") as text_file:
    text_file.write(RV523_blackbox)

print(f"Writing RV523_cells.lef")
with open("RV523_cells.lef", "w") as text_file:
    text_file.write(RV523_lef)


