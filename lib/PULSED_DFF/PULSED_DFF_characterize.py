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
    
def DFF_characterize(out):
    out.write("transition,cout,cslew,dslew,ctoq,qslew,tsetup,thold\n")
    with open("PULSED_DFF_characterize.ckt") as f:
        circuit = f.read()
    
    ns = 1e-9
    pF = 1e-12
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
        
        nominal = measure(params, transition[1])
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
       
    for cout in [5*pF, 10*pF, 20*pF, 40*pF, 60*pF, 80*pF, 100*pF]:
        for Cslew in [10*ns, 20*ns, 40*ns, 100*ns, 150*ns]:
            for Dslew in [10*ns, 20*ns, 40*ns, 100*ns, 150*ns]:
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
                    
readMeasurements("PULSED_DFF.csv")
    
#print(measurements)


with open("PULSED_DFF.csv", "w") as out:
    DFF_characterize(out)
