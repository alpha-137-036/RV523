# generate_1bit_pwl.py

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

def build_pwl():
    entries_a = []

    def append(time, value):
        entries_a.append(pwl_entry("A", time, value & 1))

    t = 0

    prev = 0
    for value in generateInputSequence(2):
        print(f"{t}: -> {value}")
        append(t, prev)
        t += transition_time
        append(t, value)
        t += cycle_time - transition_time
        prev = value
    return entries_a

def write_pwl(f, entries, node_name):
    f.write(f"* PWL waveform for {node_name}\n")
    f.write(f"V{node_name} {node_name} 0 PWL(\n  +" + "\n+  ".join(entries) + "\n+)\n")

if __name__ == "__main__":
    a = build_pwl()
    with open("pwl_Inputs.sp", 'w') as f:
        write_pwl(f, a, "A")
    print("Generated: pwl_Inputs.sp")