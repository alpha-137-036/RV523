package org.rv523;

import java.io.File;
import java.io.IOException;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) throws IOException {
        Trace trace = Trace.parse(new File("sw/build/test_fibonacci.hex"), new File("trace.txt"));
        TraceAccessor accessor = new TraceAccessor(trace);
        accessor.gotoTime(0.000016);
        accessor.gotoTime(0.000014);

        new RSPServer(new File("sw/build/test_fibonacci.elf"), 1234).run(accessor);
    }
}