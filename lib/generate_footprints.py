import pyjson5 as json5
import subprocess
import re
import uuid

from jinja2 import Template

with open('Cell.kicad_mod.j2') as f:
    template = Template(f.read())

warnings = []
def warning(msg):
    global warnings
    warnings.append(msg)
    print(f"WARNING: {msg}")

def generateAllFootprints():
    with open("RV523_cells.json5") as f:
        cellList = json5.decode(f.read())

    for cell_name in cellList:
        print(f"[{cell_name}]")
        try:
            with open(f"{cell_name}/{cell_name}_config.json5", "r") as f:
                cell_config = json5.decode(f.read())
                generateFootprint(cell_name, cell_config)
        except IOError: 
            warning(f"Missing {cell_name}_config.json5")


def getSiteCoordinates(index):
    return {
        "x": index - 0.5,
        "y": 2.25 if index % 2 == 0 else 1.75
    }

def generateFootprint(cell_name, cell_config):
    template_data = { "name": cell_name, "width": cell_config["width"], "via_sites": [], "pads": []}
    for pin_name, pin_config in cell_config["pins"].items():
        pin_coordinates = getSiteCoordinates(pin_config)
        template_data["pads"].append({
            "name": pin_name,
            "x": pin_coordinates["x"], "y": pin_coordinates["y"],
            "uuid": uuid.uuid5(uuid.NAMESPACE_URL, f"pad-{pin_name}")
        })
    # TODO: make that optional depending on pin_config?
    for i in range(1, cell_config["width"] + 1):
        if not i in cell_config["pins"].values():
            site_coordinates = getSiteCoordinates(i)
            template_data["via_sites"].append({
                "x": site_coordinates["x"], "y": site_coordinates["y"],
                "uuid": uuid.uuid5(uuid.NAMESPACE_URL, f"site-{i}")
            })
    with open(f"RV523.pretty/{cell_name}.kicad_mod", "w") as f:
        f.write(template.render(template_data))

generateAllFootprints()
