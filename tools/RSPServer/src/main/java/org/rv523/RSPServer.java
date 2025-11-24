package org.rv523;

import java.io.*;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.HexFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RSPServer {
    final int portNumber;
    File execFile;
    TraceAccessor accessor;
    public RSPServer(File execFile, int portNumber) {
        this.execFile = execFile;
        this.portNumber = portNumber;
    }

    private InputStream in;
    private OutputStream out;

    char readByte() throws IOException {
        int x = in.read();
        if (x < 0) {
            throw new EOFException();
        }
        return (char)x;
    }

    String readPacket() throws IOException {
        StringBuilder sb = new StringBuilder();
        char x;
        while (true) {
            x = readByte();
            if (x == '+') {
                // skip acknowledgments
                continue;
            } else if (x != '$') {
                throw new IOException(String.format("Invalid first packet character: %c", x));
            } else {
                break;
            }
        }
        // Start of packet
        while (true) {
            x = readByte();
            if (x == '}') {
                // escape
                x = readByte();
                sb.append((char)(x ^ 0x20));
            } else if (x == '#') {
                // don't care about checksum
                readByte();
                readByte();
                break;
            } else {
                sb.append(x);
            }
        }
        System.out.printf("-> %s\n", sb);
        // Aknowledge packet
        out.write('+');
        return sb.toString();
    }

    public void sendPacket(String packet) throws IOException {
        System.out.printf("<- %s\n", packet);
        out.write('$');
        int checksum = 0;
        for (int i = 0; i < packet.length(); i++) {
            char c = packet.charAt(i);
            if (c == '#' || c == '$' || c == '}' || c == '*') {
                // escape
                out.write('}');
                out.write(c ^ 0x20);
                checksum += '}';
                checksum += c ^ 0x20;
            } else {
                out.write(c);
                checksum += c;
            }
        }
        out.write('#');
        out.write(String.format("%02X", checksum & 0xFF).getBytes(StandardCharsets.US_ASCII));
        out.flush();
    }

    String formatInteger(int x) {
        return String.format("%02X%02X%02X%02X", x & 0xFF, (x >> 8) & 0xFF, (x >> 16) & 0xFF, (x >> 24) & 0xFF);
    }

    String getAllRegisters() {
        StringBuilder sb = new StringBuilder();

        // X0-X31
        for (int i = 0; i < 32; i++) {
            sb.append(formatInteger(accessor.x[i]));
        }
        // PC
        sb.append(formatInteger(accessor.PC));
        return sb.toString();
    }

    String getMemory(int addr, int length) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int x = accessor.getMemoryByte(addr + i);
            if (x < 0) {
                return "E01";
            } else {
                sb.append(String.format("%02X", x));
            }
        }
        return sb.toString();
    }

    String encodeQxferResponse(InputStream in, int offset, int length) throws IOException {
        try {
            in.skipNBytes(offset);
        } catch (EOFException e) {
            return "l";
        }
        StringBuilder sb = new StringBuilder();
        sb.setLength(1);
        for (int i = 0; i < length; i++) {
            int x = in.read();
            if (x < 0) {
                sb.setCharAt(0, 'l');
                return sb.toString();
            }
            sb.append((char)x);
        }
        if (in.read() < 0) {
            sb.setCharAt(0, 'l');
        } else {
            sb.setCharAt(0, 'm');
        }
        return sb.toString();
    }

    String encodeQxferResponse(byte[] data, int offset, int length) throws IOException {
        return encodeQxferResponse(new ByteArrayInputStream(data), offset, length);
    }


    String getResource(String name, int offset, int length) throws IOException {
        try (InputStream in = new BufferedInputStream(RSPServer.class.getResourceAsStream(name))) {
            return encodeQxferResponse(in, offset, length);
        }
    }

    String getExecFile(int offset, int length) throws IOException {
        try (InputStream in = new BufferedInputStream(new FileInputStream(execFile))) {
            return encodeQxferResponse(in, offset, length);
        }
    }
    final static Pattern MEMORY_READ_PATTERN = Pattern.compile("m([0-9a-fA-F]+),([0-9a-fA-F]+)");
    final static Pattern SOFTWARE_BREAKPOINT_PATTERN = Pattern.compile("([zZ])0,([0-9a-fA-F]+),([0-9a-fA-F]+)");
    final static Pattern QXFER_READ_PATTERN = Pattern.compile("qXfer:(.*?):read:(.*?):([0-9a-fA-F]+),([0-9a-fA-F]+)");
    final static Pattern FILE_OPEN_PATTERN = Pattern.compile("vFile:open:([0-9a-fA-F]+),0,0");

    public void run(TraceAccessor accessor) throws IOException {
        this.accessor = accessor;
        // Bind explicitly to 0.0.0.0 (all interfaces)
        InetAddress bindAddr = InetAddress.getByName("0.0.0.0");
        ServerSocket server = new ServerSocket(portNumber, 50, bindAddr);
        System.err.printf("Waiting on port %d%n", portNumber);
        Socket client = server.accept();
        in = new BufferedInputStream(client.getInputStream());
        out = new BufferedOutputStream(client.getOutputStream());

        while (true) {
            Matcher matcher;
            String packet = readPacket();
            if (packet.startsWith("qSupported")) {
                sendPacket("PacketSize=4000;hwbreak+;ReverseContinue+;qXfer:features:read+"); // ;qXfer:exec-file:read+
            } else if ((matcher = QXFER_READ_PATTERN.matcher(packet)).matches()) {
                String type = matcher.group(1);
                String annex = matcher.group(2);
                int offset = Integer.parseInt(matcher.group(3), 16);
                int length = Integer.parseInt(matcher.group(4), 16);
                if (type.equals("features") && annex.equals("target.xml")) {
                    sendPacket(getResource("/target.xml", offset, length));
                } else if (type.equals("exec-file") && annex.equals("")) {
                    sendPacket(encodeQxferResponse(execFile.getAbsolutePath().getBytes(StandardCharsets.UTF_8), offset, length));
                } else {
                    sendPacket("l");
                }
            } else if (packet.startsWith("qOffsets")) {
                sendPacket("Text=0;Data=0;Bss=0");
            } else if (packet.startsWith("?")) {
                sendPacket("S05"); // Stop due to TRAP exception
//            } else if (packet.equals("vCont?")) {
//                sendPacket("OK");
            } else if (packet.equals("qSymbol::")) {
                sendPacket("OK");
            } else if (packet.equals("g")) {
                sendPacket(getAllRegisters());
            } else if ((matcher = MEMORY_READ_PATTERN.matcher(packet)).matches()) {
                int addr = Integer.parseUnsignedInt(matcher.group(1), 16);
                int length = Integer.parseUnsignedInt(matcher.group(2), 16);
                sendPacket(getMemory(addr, length));
            } else if ((matcher = SOFTWARE_BREAKPOINT_PATTERN.matcher(packet)).matches()) {
                boolean add = matcher.group(1).equals("Z");
                int addr = Integer.parseUnsignedInt(matcher.group(2), 16);
                int length = Integer.parseUnsignedInt(matcher.group(3), 16);
                if (add) {
                    accessor.addBreakpoint(addr, length);
                } else {
                    accessor.removeBreakpoint(addr, length);
                }
                sendPacket("OK");
            } else if (packet.equals("c") || packet.equals("bc")) {
                accessor.run(packet.equals("c") ? +1 : -1, () -> {
                    try {
                        return in.available() != 0;
                    } catch (IOException e) {
                        return true;
                    }
                });
                sendPacket("S05");
            } else if (packet.equals("vFile:setfs:0")) {
                sendPacket("F0");
            } else if ((matcher = FILE_OPEN_PATTERN.matcher(packet)).matches()) {
                String filenameHex = matcher.group(1);
                byte[] filenameBin = HexFormat.of().parseHex(filenameHex);
                String filename = new String(filenameBin, StandardCharsets.UTF_8);

                sendPacket("F1");
            } else {
                // Unknown packet
                sendPacket("");
            }
        }
    }
}
