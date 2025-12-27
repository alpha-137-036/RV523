import subprocess
import re
import math
import matplotlib.pyplot as plt
import csv
from dataclasses import dataclass

@dataclass(frozen=True)
class Inputs:
    cout: float
    cslew: float
    dslew: float
    transition: int
    
    
@dataclass
class Measurement:
    inputs: Inputs
    ctoq: float
    qslew: float
    tsetup: float
    thold: float
    
    def toCSV(self):
        transitionFrom = 1-self.inputs.transition
        transitionTo = self.inputs.transition
        return f"'{transitionFrom}{transitionTo},{self.inputs.cout},{self.inputs.cslew},{self.inputs.dslew},{self.ctoq},{self.qslew},{self.tsetup},{self.thold}"

measurements = {}

def readMeasurements(filename):
    try:
        with open(filename, "r", newline='') as infile:
            reader = csv.DictReader(infile)
            for row in reader:
                inputs = Inputs(cout=float(row['cout']), cslew=float(row['cslew']), dslew=float(row['dslew']), transition=1 if row['transition']=="'01" else 0)
                measurement = Measurement(inputs=inputs,ctoq=float(row['ctoq']), qslew=float(row['qslew']), tsetup=float(row['tsetup']), thold=float(row['thold']))
                measurements[inputs] = measurement
    except FileNotFoundError as e:
        print(e)

ns = 1e-9
pF = 1e-12
out_caps = [5*pF, 10*pF, 20*pF, 40*pF, 60*pF, 80*pF, 100*pF, 150*pF, 200*pF]
slews = [10*ns, 20*ns, 40*ns, 100*ns, 150*ns]

def DFF_characterize(out):
    out.write("transition,cout,cslew,dslew,ctoq,qslew,tsetup,thold\n")
    with open("PULSED_DFF_ASYNC_RESET_characterize.ckt") as f:
        circuit = f.read()

    def measure(params, expectedLatched):    
        paramsDefs = "\n".join(f".param {k}={v}" for k,v in params.items())
        ckt = f"""
.title PULSED_DFF
{paramsDefs}
.control
    run
    * write PULSED_DFF_characterize.raw
    quit
.endc
{circuit}
        """
        #print(ckt)
        result = subprocess.run(["ngspice"], 
            input=ckt,
            capture_output=True, 
            text=True)
        #print(result.stdout)
    
        def getMeasurement(id):
            m = re.search(fr'{id} *= *([0-9.e+-]+)', result.stdout)
            if not m: 
                return math.nan
            else:
                return float(m.group(1))
            
        # Check validity of latched Q
        if expectedLatched == 0:
            valid = getMeasurement("qlatched") < 3.3 * 0.1
        else:
            valid = getMeasurement("qlatched") > 3.3 * 0.9
        if valid:
            result = {"valid": True, "ctoq": getMeasurement("clocktoq"), "qslew": getMeasurement("qslew")}
        else:
            result = {"valid": False, "ctoq": math.inf, "qslew": math.inf}
        print(result)
        return result
       
    def measureAll(inputs):
        transitionFrom = 1-inputs.transition
        transitionTo = inputs.transition
        params = {
            "vdd": 3.3,
            "Va": f"{{{transitionFrom}*vdd}}",
            "Vb": f"{{{transitionTo}*vdd}}",
            "cout": inputs.cout * pF,
            "CSlew": inputs.cslew * ns,
            "DSlew": inputs.dslew * ns,
        }

        params["Thold"] = 800*ns
        params["Tsetup"] = 800*ns
        
        nominal = measure(params, transitionTo)
        ctoq_nominal = nominal["ctoq"]
        qslew = nominal["qslew"]
        print(f"Nominal C-to-Q: {ctoq_nominal/ns:.1f}ns, qslew={qslew/ns:.1f}ns")

        ctoq_max = ctoq_nominal * 1.1
        
        def binary_search(param):
            max = 500*ns
            min = -50*ns
            
            while max - min > 0.1*ns:
                x = (max + min) / 2
                params[param] = x
                result = measure(params, transition[1])
                ctoq = result['ctoq']
                print(f"{param}={x/ns:.1f}ns => ctoq={ctoq/ns:.1f}ns {'OK' if ctoq < ctoq_max else 'NOK'}")
                if (ctoq < ctoq_max):
                    max = x
                else:
                    min = x
            print(f"{param} ===> {x/ns:.1f}ns")
            return x
        thold=binary_search("Thold")
        params["Thold"] = 500*ns
        tsetup=binary_search("Tsetup")
        measurement = Measurement(inputs=inputs,ctoq=ctoq_nominal/ns, qslew=qslew/ns,tsetup=tsetup/ns,thold=thold/ns)
        return measurement        
       
    for cout in out_caps:
        for Cslew in slews:
            for Dslew in slews:
                for transition in [(0,1), (1,0)]:
                    print(f"Transition: {transition[0]}->{transition[1]}: Cslew={Cslew/ns:.1f}ns, Dslew={Dslew/ns:.1f}, cout={cout/pF:.0f}pF")

                    inputs = Inputs(cout=cout/pF, cslew=Cslew/ns, dslew=Dslew/ns, transition=transition[1])
                    if inputs in measurements:
                        measurement = measurements[inputs]
                    else:
                        measurement = measureAll(inputs)
                    out.write(measurement.toCSV())
                    out.write("\n")
                    out.flush()
                    measurements[inputs] = measurement
                    print(measurement)

def print_lut_table(table_name, template_name, input_1, input_2, values):
    print(f"{table_name}({template_name}) {{")
    print(f"    input_1({','.join(str(x) for x in input_1)});")
    print(f"    input_2({','.join(str(x) for x in input_2)});")
    print("    values(")
    for i in range(len(input_1)):
        print("        \"", end="")
        for j in range(len(input_2)):
            print(values[i*len(input_2)+j], end="," if j < len(input_2)-1 else "")
        print("\"", end="")
        print("," if i < len(input_1)-1 else "")
    print("    );")
    print("}")


def print_tables():
    for kind in ["cell", "transition"]:
        for direction in ["rise", "fall"]:
            if kind == "cell":
                table_name = kind + "_" + direction
                key = "ctoq"
            else:
                table_name = direction + "_" + kind
                key = "qslew"
            values = []
            for slew in slews:
                for cap in out_caps:
                    inputs = Inputs(transition=1 if direction=="rise" else 0, dslew=10.0, cslew=slew/ns, cout=cap/pF)
                    measurement = measurements[inputs]
                    values.append(getattr(measurement, key))

            print_lut_table(
                table_name,
                f"delay_template_{len(slews)}x{len(out_caps)}",
                [x/ns for x in slews],
                [x/pF for x in out_caps],
                values)

    for kind in ["setup", "hold"]:
        print(f"timing_type : {kind}_rising;")
        for direction in ["rise", "fall"]:
            values = []
            for dslew in slews:
                for cslew in slews:
                    inputs = Inputs(transition=1 if direction=="rise" else 0, dslew=dslew/ns, cslew=cslew/ns, cout=out_caps[0]/pF)
                    measurement = measurements[inputs]
                    values.append(getattr(measurement, "t"+kind))
            print_lut_table(f"{direction}_constraint", f"{kind}_{len(slews)}x{len(slews)}",
                [x/ns for x in slews],
                [x/ns for x in slews],
                values)

readMeasurements("PULSED_DFF_ASYNC_RESET.csv")
    
#print(measurements)


with open("PULSED_DFF_ASYNC_RESET.csv", "w") as out:
    DFF_characterize(out)

print_tables()

