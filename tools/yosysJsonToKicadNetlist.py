import json
import argparse
import re

argParser = argparse.ArgumentParser("Yosys JSON netlist to Kicad netlist")
argParser.add_argument("filename", help="input Yosys netlist")
argParser.add_argument("outputFilename", help="output Kicad netlist")
argParser.add_argument("--spice", help="Spice netlist")
args = argParser.parse_args()

with open(args.filename, 'r') as file:
    data = json.load(file)

# Add name of modules and cells to the data
def processNames():
    for name, module in data["modules"].items():
        module["name"] = name
        for itemKind in ["cells", "ports", "netnames"]:
            for itemName, item in module[itemKind].items():
                item["name"] = itemName
processNames()

# Find the top module
def getTopModule():
    for module in data["modules"].values():
        if "top" in module["attributes"]:
            return module
topModule = getTopModule()

def buildName(baseName, idx):
    while True:
        match = re.search("^(.*?)\\[([0-9]+):([0-9]+)\\]$", baseName)
        if match:
            baseName = match.group(1)
            rangeLow = int(match.group(2))
            rangeHigh = int(match.group(3))
            if rangeLow <= rangeHigh:
                idx = rangeHigh - idx
            else:
                idx = rangeHigh + idx                    
        else:
            return baseName + "." + str(idx)


def getPinName(cellNet, pinIdx):
    bits = cellNet["bits"]
    if len(bits) == 1:
        return cellNet["name"]
    else:
        offset = cellNet.get("offset", 0)
        upto = cellNet.get("upto", 0)
        if upto:
            pinVerilogNumber = offset + len(bits) - 1 - pinIdx 
        else:
            pinVerilogNumber = offset + pinIdx 
        return buildName(cellNet["name"], pinVerilogNumber)
    
def getPinNumber(cellNet, pinIdx):
    if not "num" in cellNet["attributes"]:
        return None
    else:
        num = cellNet["attributes"]["num"]
        bits = cellNet["bits"]
        if len(bits) == 1:
            return int(num)
        else:
            [numFirst, numLast] = num.split(":")
            numFirst = int(numFirst)
            numLast = int(numLast)
            if abs(numLast - numFirst) + 1 != len(bits):
                raise Exception(f"Mismatch for bus width: {num} vs {len(bits)} bits")
            upto = cellNet.get("upto", 0)
            idxInRange = len(bits) - 1 - pinIdx
            if numFirst <= numLast:
                pinNumber = numFirst + idxInRange
            else:
                pinNumber = numFirst - idxInRange
            return pinNumber


nets = {}
cells = []

print(f"Writing {args.outputFilename}")
with open(args.outputFilename, 'w') as output:
    output.write("(export (version \"E\")\n")

    output.write("(components \n")
    for cell in topModule["cells"].values():
        type = cell["type"]
        if (type != "$scopeinfo"):
            cellModule = data["modules"][type]
            if not cellModule:
                raise Exception(f"Module {type} not found")
            cells.append({ 
                "name": cell["name"], 
                "cellModule": cellModule,
                "type": type
            })
            output.write(f"   (comp (ref \"{cell["name"]}\")\n")
            footprint = cellModule["attributes"]["footprint"]
            output.write(f"      (footprint \"{footprint}\")\n")
            for pin, wireIDs in cell["connections"].items():
                for wireIdx, wireID in enumerate(wireIDs):
                    if wireID == "x":
                        raise Exception(f"cell {cell["name"]} is connected to 'x")
                    cellNet = cellModule["netnames"][pin]
                    pinName = getPinName(cellNet, wireIdx)
                    net = nets.setdefault(wireID, {"toto": True, "id": wireID, "nodes": []})
                    pintype = cell["port_directions"][pin]
                    pinData = {
                        "ref": cell["name"],
                        "pin": pinName,
                        "pinfunction": pinName,
                        "pintype": pintype
                    }
                    pinNumber = getPinNumber(cellNet, wireIdx)
                    if pinNumber is not None:
                        pinData["pin"] = pinNumber
                        cells[-1].setdefault("pins", {})[pinNumber] = net
                    net["nodes"].append(pinData)
            output.write("   )\n")
    output.write(")\n")

    for netKind in ["ports", "netnames"]:
        for netData in topModule[netKind].values():
            # normalize name
            name = netData["name"]
            if name.endswith(".GND"):
                name = "GND"
            if name.endswith(".VDD"):
                name = "VDD"
            for i, wireID in enumerate(netData["bits"]):
                net = nets.setdefault(wireID, {"id": wireID, "nodes": []})

                if "name" not in net or name == "GND" or name == "VDD":
                    if (len(netData["bits"]) == 1):
                        net["name"] = name
                    else:
                        net["name"] = buildName(name, i)

    output.write("(nets\n")
    for net in nets.values():
        if net['name'] == "GND" or net['name'] == "VDD":
            netClass = "Power"
        else:
            netClass = "Default"
        # gotcha: net with code "0" is not accepted by Kicad. Add one to all net IDs...
        # gotcha#2: "0" and "1" are strings, not ints...
        output.write(f"   (net (code \"{1+int(net['id'])}\") (class \"{netClass}\")")
        if "name" in net:
            output.write(f" (name \"{net['name']}\")")
        output.write("\n")
        for node in net["nodes"]:
            output.write(f"      (node (ref \"{node['ref']}\") (pin \"{node['pin']}\") (pinfunction \"{node['pinfunction']}\") (pintype \"{node['pintype']}\"))\n")
        output.write("   )\n")
    output.write(")\n")

    output.write(")")

if args.spice:
    print(f"Writing {args.spice}")
    with open(args.spice, "w") as output:
        output.write(".inc \"../RV523_NMOS.ckt\"\n")
        output.write(".inc \"../RV523_PMOS.ckt\"\n")
        output.write(f".subckt {topModule["name"]}")
        for portName in topModule["ports"]:
            output.write(f" {portName}")
        output.write("\n")
        for cell in cells:
            output.write(f" X{cell["name"]}")
            for pinNumber in sorted(cell["pins"]):
                netName = cell["pins"][pinNumber]["name"]
                if netName == "GND":
                    netName = 0
                output.write(f" {netName}")
            output.write(f" {cell["type"]}\n")

        output.write(".ends\n")
