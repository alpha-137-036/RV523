# generate_3bit_pwl.py
# Generates PWL waveforms for N inputs covering every possible transitions

VDD = 3.3
transition_time = 30 # nanoseconds per transition
cycle_time = 200 # nanoseconds per cycle

# generate a minimal sequence containing all transitions among the values in [0, n-1] 
def generateInputSequence(n):
    sequence = []
    for i in range(n):
        for j in range(i+1, n):
            sequence.append(i)
            sequence.append(j)
    sequence.append(0)
    return sequence

def pwl_entry(signal, time, value):
    return f"{time:.1f}n {VDD if value else 0.0:.1f}V"

def build_pwl(inputNames):
    entries = [[] for input in inputNames]

    def append(time, value):
        for i in range(len(inputNames)):
            entries[i].append(pwl_entry(inputNames[i], time, (value >> i) & 1))

    t = 0

    prev = 0
    for value in generateInputSequence(1 << len(inputNames)):
        print(f"{t}: -> {value}")
        append(t, prev)
        t += transition_time
        append(t, value)
        t += cycle_time - transition_time
        prev = value
    return entries

def write_pwl(f, entries, node_name):
    f.write(f"* PWL waveform for {node_name}\n")
    f.write(f"V{node_name} {node_name} 0 PWL({' '.join(entries)})\n")

def generate_pwl(filename, inputNames):
    entries = build_pwl(inputNames)
    with open(filename, 'w') as f:
        for i in range(len(inputNames)):
            write_pwl(f, entries[i], inputNames[i])
    print(f"Generated: {filename}")
