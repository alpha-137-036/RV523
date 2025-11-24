package org.rv523;

import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class Indexer {
    Indexer(Trace trace) {
        this.trace = trace;
    }
    final Trace trace;
    int x[] = new int[32];
    int PC;
    int ram[] = new int[1024];
    double time;

    // Mem update differed until next time
    int memAddr;
    int memData;
    boolean memStorePending;

    final static Pattern TIME_PATTERN = Pattern.compile("------- ([0-9\\.]+) *");
    final static Pattern REG_UPDATE_PATTERN = Pattern.compile("\\[ WB\\] *x([0-9]+) <- ([0-9a-fA-F]+) *");
    final static Pattern PC_PATTERN = Pattern.compile("\\[ WB\\] *([0-9a-fA-F]+) .*");
    final static Pattern MEM_UPDATE_PATTERN = Pattern.compile("\\[MEM\\] *store ([0-9a-fA-F]+) -> ([0-9a-fA-F]+)");

    void parseCode(InputStream in) throws IOException {
        int address = 0;
        try (BufferedReader bin = new BufferedReader(new InputStreamReader(in))) {
            String line;
            while ((line = bin.readLine()) != null) {
                int data = Integer.parseUnsignedInt(line, 16);
                trace.code[address / 4] = data;
                address += 4;
            }
        }
    }

    void parseTrace(InputStream in) throws IOException {
        try (BufferedReader bin = new BufferedReader(new InputStreamReader(in))) {
            String line;
            while ((line = bin.readLine()) != null) {
                Matcher matcher;
                if ((matcher = TIME_PATTERN.matcher(line)).matches()) {
                    double time = Double.parseDouble(matcher.group(1));
                    trace.events.add(trace.new TimeEvent(this.time, time));
                    this.time = time;
                    if (memStorePending) {
                        trace.events.add(trace.new MemUpdateEvent(
                                memAddr,
                                ram[memAddr - 0x2000_0000],
                                memData
                        ));
                        ram[memAddr - 0x2000_0000] = memData;
                        memStorePending = false;
                    }
                } else if ((matcher = REG_UPDATE_PATTERN.matcher(line)).matches()) {
                    int regIdx = Integer.parseInt(matcher.group(1));
                    int newValue = Integer.parseUnsignedInt(matcher.group(2), 16);
                    trace.events.add(trace.new RegisterUpdateEvent(
                            regIdx,
                            x[regIdx],
                            newValue
                    ));
                    x[regIdx] = newValue;
                } else if ((matcher = PC_PATTERN.matcher(line)).matches()) {
                    int newPC = Integer.parseUnsignedInt(matcher.group(1), 16);
                    trace.events.add(trace.new PCEvent(this.PC, newPC));
                    this.PC = newPC;
                } else if ((matcher = MEM_UPDATE_PATTERN.matcher(line)).matches()) {
                    this.memStorePending = true;
                    this.memData = Integer.parseUnsignedInt(matcher.group(1), 16);
                    this.memAddr = Integer.parseUnsignedInt(matcher.group(2), 16);
                }
            }
        }
    }
}
