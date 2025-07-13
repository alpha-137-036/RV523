import json
import argparse

argParser = argparse.ArgumentParser("Yosys JSON netlist to Kicad netlist")
argParser.add_argument("filename", help="input Yosys netlist")
argParser.add_argument("outputFilename", help="output Kicad netlist")
args = argParser.parse_args()

with open(args.filename, 'r') as file:
    data = json.load(file)

# Find the top module

for name, module in data["modules"].items():
    if "top" in module["attributes"]:
        global topModule
        topModule = module

with open(args.outputFilename, 'w') as output:
    output.write("(export (version \"E\")\n")

    nets = {}
    parts = {}

    output.write("(components \n")
    for name, cell in topModule["cells"].items():
        type = cell["type"]
        if (type != "$scopeinfo"):
            cellModule = data["modules"][type]
            if not cellModule:
                raise Exception(f"Module {type} not found")
            output.write(f"   (comp (ref \"{name}\")\n")
            footprint = cellModule["attributes"]["footprint"]
            output.write(f"      (footprint \"{footprint}\")\n")
            if not type in parts.keys():
                pins = []
                for pinName, direction in cell["port_directions"].items():
                    pins.append({"name": pinName, "type": direction})
                parts[type] = {"name": type, "pins": pins}
            for pin, wireIDs in cell["connections"].items():
                for wireID in wireIDs:
                    net = nets.setdefault(wireID, {"id": wireID})
                    nodes = net.setdefault("nodes", [])
                    pintype = cell["port_directions"][pin]
                    pinData = {
                        "ref": name,
                        "pin": pin,
                        "pinfunction": pin,
                        "pintype": pintype
                    }
                    if pin in cellModule["netnames"] and "num" in cellModule["netnames"][pin]["attributes"]:
                        pinData["pin"] = int(cellModule["netnames"][pin]["attributes"]["num"])
                    nodes.append(pinData)
            output.write("   )\n")
    output.write(")\n")

    for name, netData in topModule["netnames"].items():
        for i, wireID in enumerate(netData["bits"]):
            net = nets.setdefault(wireID, {"id": wireID})
            if (len(netData["bits"]) == 1):
                net["name"] = name
            else:
                net["name"] = name + "." + str(i)

    # output.write("(libparts\n")
    # for part in parts.values():
    #     footprint = data["modules"][part['name']]["attributes"]["footprint"]
    #     (lib,name) = footprint.split(':')
    #     output.write(f"   (libpart (lib \"{lib}\") (part \"{name}\")\n")
    #     output.write(f"      (pins\n")
    #     for pin in part["pins"]:
    #         output.write(f"         (pin (num \"{pin['name']}\") (name \"{pin['name']}\") (type \"{pin['type']}\"))\n")
    #     output.write(f"      )")
    #     output.write("   )\n")
    # output.write(")\n")

    output.write("(nets\n")
    for net in nets.values():
        # gotcha: net with code "0" is not accepted by Kicad. Add one to all net IDs...
        # gotha#2: "0" and "1" are strings, not ints...
        output.write(f"   (net (code \"{1+int(net['id'])}\") (class \"Default\")")
        if "name" in net:
            output.write(f" (name \"{net['name']}\")")
        output.write("\n")
        for node in net["nodes"]:
            output.write(f"      (node (ref \"{node['ref']}\") (pin \"{node['pin']}\") (pinfunction \"{node['pinfunction']}\") (pintype \"{node['pintype']}\"))\n")
        output.write("   )\n")
    output.write(")\n")

    output.write(")")
