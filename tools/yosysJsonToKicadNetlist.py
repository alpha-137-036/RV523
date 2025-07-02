import json

with open('test_kicad.json', 'r') as file:
    data = json.load(file)

with open('test_kicad.net', 'w') as output:

    module = data["modules"]["adder"]

    output.write("(export (version \"E\")\n")

    nets = {}
    parts = {}

    output.write("(components \n")
    for name, cell in module["cells"].items():
        if (cell["type"] != "$scopeinfo"):
            output.write(f"   (comp (ref \"{name}\")\n")
            output.write(f"      (footprint \"RVCMOS:{cell['type']}\")\n")
            output.write(f"      (libsource (lib \"RVCMOS\") (part \"{cell['type']}\"))\n")
            if not cell['type'] in parts.keys():
                pins = []
                for pinName, direction in cell["port_directions"].items():
                    pins.append({"name": pinName, "type": direction})
                parts[cell['type']] = {"name": cell['type'], "pins": pins}
            for pin, wireIDs in cell["connections"].items():
                for wireID in wireIDs:
                    net = nets.setdefault(wireID, {"id": wireID})
                    nodes = net.setdefault("nodes", [])
                    pintype = cell["port_directions"][pin]
                    nodes.append({
                        "ref": name,
                        "pin": pin,
                        "pintype": pintype
                    })
            output.write("   )\n")
    output.write(")\n")

    for name, data in module["netnames"].items():
        for i, wireID in enumerate(data["bits"]):
            net = nets.setdefault(wireID, {"id": wireID})
            if (len(data["bits"]) == 1):
                net["name"] = name
            else:
                net["name"] = name + "." + str(i)

    output.write("(libparts\n")
    for part in parts.values():
        output.write(f"   (libpart (lib \"RVMOS\") (part \"{part['name']}\")\n")
        output.write(f"      (pins\n")
        for pin in part["pins"]:
            output.write(f"         (pin (num \"{pin['name']}\") (name \"{pin['name']}\") (type \"{pin['type']}\"))\n")
        output.write(f"      )")
        output.write("   )\n")
    output.write(")\n")

    output.write("(nets\n")
    for net in nets.values():
        output.write(f"   (net (code \"{net['id']}\") (class \"Default\")")
        if "name" in net:
            output.write(f" (name \"{net['name']}\")")
        output.write("\n")
        for node in net["nodes"]:
            output.write(f"      (node (ref \"{node['ref']}\") (pin \"{node['pin']}\") (pinfunction \"{node['pin']}\") (pintype \"{node['pintype']}\"))\n")
        output.write("   )\n")
    output.write(")\n")

    output.write(")")
