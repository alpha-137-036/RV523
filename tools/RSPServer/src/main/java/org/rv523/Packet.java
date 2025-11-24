package org.rv523;

public class Packet {
    final String data;

    public Packet(String data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return data;
    }
}
