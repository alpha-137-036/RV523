package org.rv523;

import org.rv523.Trace.*;

import java.util.Set;
import java.util.TreeSet;
import java.util.function.Supplier;

public class TraceAccessor {
    TraceAccessor(Trace trace) {
        this.trace = trace;
    }
    final Trace trace;
    int x[] = new int[32];
    int PC;
    int ram[] = new int[1024];
    double time;
    int eventID;

    Set<Integer> breakpoints = new TreeSet<>();

    void execute(Event event, boolean forward) {
        switch(event) {
            case TimeEvent t ->
                this.time = forward ? t.newTime : t.oldTime;
            case PCEvent p ->
                this.PC = forward ? p.newValue : p.oldValue;
            case RegisterUpdateEvent r ->
                this.x[r.regIdx] = forward ? r.newValue : r.oldValue;
            case MemUpdateEvent m ->
                this.ram[(m.addr - 0x20000000) / 4] = forward ? m.newValue : m.oldValue;
        }
    }

    void gotoTime(double time) {
        if (time > this.time) {
            while (eventID+1 < trace.events.size() && time > this.time) {
                eventID++;
                execute(trace.events.get(eventID), true);
            }
        } else if (time < this.time) {
            while (eventID-1 >= 0 && time < this.time) {
                eventID--;
                execute(trace.events.get(eventID), false);
            }
        }
        System.err.printf("At time %.6f\n", this.time);
    }

    final static int CODE_ADDRESS = 0x0000_0000;
    final static int RAM_ADDRESS  = 0x2000_0000;

    /** Get a byte of memory or -1 if not mapped */
    int getMemoryByte(int addr) {
        if (Integer.compareUnsigned(addr, RAM_ADDRESS) >= 0
                && Integer.compareUnsigned(addr, RAM_ADDRESS + ram.length * 4) < 0)
        {
            int wordIndex = (addr - RAM_ADDRESS) / 4;
            int word = ram[wordIndex];
            return (word >> ((addr & 3) * 8)) & 0xFF;
        }
        if (Integer.compareUnsigned(addr, CODE_ADDRESS) >= 0
                && Integer.compareUnsigned(addr, CODE_ADDRESS + trace.code.length * 4) < 0)
        {
            int wordIndex = (addr - CODE_ADDRESS) / 4;
            int word = trace.code[wordIndex];
            return (word >> ((addr & 3) * 8)) & 0xFF;
        }
        return -1;
    }

    void addBreakpoint(int addr, int length) {
        for (int i = 0; i < length; i++) {
            breakpoints.add(addr + i);
        }
    }
    void removeBreakpoint(int addr, int length) {
        for (int i = 0; i < length; i++) {
            breakpoints.remove(addr + i);
        }
    }

    void run(int direction, Supplier<Boolean> stopCallback) {
        while (eventID + direction >= 0 && eventID+direction < trace.events.size()) {
            eventID += direction;
            execute(trace.events.get(eventID), direction > 0);
            if (breakpoints.contains(PC)) {
                break;
            }
            if (stopCallback.get()) {
                break;
            }
        }
        System.err.printf("At eventID=%d, time=%.6f, PC=0x%08X, x10=0x%08X\n", eventID, time, PC, x[10]);
    }
}
