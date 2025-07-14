import json
import argparse

argParser = argparse.ArgumentParser("Yosys JSON netlist to Kicad netlist")
argParser.add_argument("filename", help="input Yosys netlist")
argParser.add_argument("outputFilename", help="output Kicad netlist")
argParser.add_argument("--spice", help="Spice netlist")
args = argParser.parse_args()

with open(args.filename, 'r') as file:
    data = json.load(file)

# Find the top module

for name, module in data["modules"].items():
    if "top" in module["attributes"]:
        global topModule
        global topModuleName
        topModule = module
        topModuleName = name

nets = {}
cells = []

print(f"Writing {args.outputFilename}")
with open(args.outputFilename, 'w') as output:
    output.write("(export (version \"E\")\n")

    output.write("(components \n")
    for name, cell in topModule["cells"].items():
        type = cell["type"]
        if (type != "$scopeinfo"):
            cellModule = data["modules"][type]
            if not cellModule:
                raise Exception(f"Module {type} not found")
            cells.append({ 
                "name": name, 
                "cellModule": cellModule,
                "type": type
            })
            output.write(f"   (comp (ref \"{name}\")\n")
            footprint = cellModule["attributes"]["footprint"]
            output.write(f"      (footprint \"{footprint}\")\n")
            for pin, wireIDs in cell["connections"].items():
                for wireID in wireIDs:
                    net = nets.setdefault(wireID, {"id": wireID, "nodes": []})
                    pintype = cell["port_directions"][pin]
                    pinData = {
                        "ref": name,
                        "pin": pin,
                        "pinfunction": pin,
                        "pintype": pintype
                    }
                    if pin in cellModule["netnames"] and "num" in cellModule["netnames"][pin]["attributes"]:
                        pinNumber = int(cellModule["netnames"][pin]["attributes"]["num"])
                        pinData["pin"] = pinNumber
                        cells[-1].setdefault("pins", {})[pinNumber] = net
                    net["nodes"].append(pinData)
            output.write("   )\n")
    output.write(")\n")

    for name, portData in topModule["ports"].items():
        for i, wireID in enumerate(portData["bits"]):
            net = nets.setdefault(wireID, {"id": wireID, "nodes": []})
            if "name" not in net:
                if (len(portData["bits"]) == 1):
                    net["name"] = name
                else:
                    net["name"] = name + "." + str(i)

    for name, netData in topModule["netnames"].items():
        for i, wireID in enumerate(netData["bits"]):
            net = nets.setdefault(wireID, {"id": wireID, "nodes": []})
            if "name" not in net or name == "GND" or name == "VDD":
                if (len(netData["bits"]) == 1):
                    net["name"] = name
                else:
                    net["name"] = name + "." + str(i)

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
        output.write(f".subckt {topModuleName}")
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
