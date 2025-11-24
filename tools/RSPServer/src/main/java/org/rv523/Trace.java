package org.rv523;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Trace {

    List<Event> events = new ArrayList<>();

    int code[] = new int[1024];

    public sealed abstract class Event {
        final int eventID = events.size();
    }

    public final class RegisterUpdateEvent extends Event {
        final int regIdx;
        final int oldValue;
        final int newValue;

        RegisterUpdateEvent(int regIdx, int oldValue, int newValue) {
            this.regIdx = regIdx;
            this.oldValue = oldValue;
            this.newValue = newValue;
        }

        @Override
        public String toString() {
            return String.format("x%d: 0x%08X -> 0x%08X", regIdx, oldValue, newValue);
        }
    }

    public final class PCEvent extends Event {
        final int oldValue;
        final int newValue;
        PCEvent(int oldValue, int newValue) {
            this.oldValue = oldValue;
            this.newValue = newValue;
        }

        @Override
        public String toString() {
            return String.format("PC: 0x%08X -> 0x%08X", oldValue, newValue);
        }
    }

    public final class MemUpdateEvent extends Event {
        final int addr;
        final int oldValue;
        final int newValue;

        MemUpdateEvent(int addr, int oldValue, int newValue) {
            this.addr = addr;
            this.oldValue = oldValue;
            this.newValue = newValue;
        }

        @Override
        public String toString() {
            return String.format("Mem[0x%08X]: 0x%08X -> 0x%08X", addr, oldValue, newValue);
        }
    }

    public final class TimeEvent extends Event {
        final double oldTime;
        final double newTime;
        TimeEvent(double oldTime, double newTime) {
            this.oldTime = oldTime;
            this.newTime = newTime;
        }

        @Override
        public String toString() {
            return String.format("t: %.6f -> %.6f", oldTime, newTime);
        }
    }


    public static Trace parse(File codeFile, File traceFile) throws IOException {
        Trace trace = new Trace();
        Indexer indexer = new Indexer(trace);
        System.err.printf("Reading %s\n", codeFile);
        try (FileInputStream in = new FileInputStream(codeFile)) {
            indexer.parseCode(in);
        }
        System.err.printf("Reading %s\n", traceFile);
        try (FileInputStream in = new FileInputStream(traceFile)) {
            indexer.parseTrace(in);
        }
        System.err.printf("%d events\n", trace.events.size());
        return trace;
    }
}
