
module SRAM_CELL(
    input WL,
    inout BL,
    inout BLB
);
    supply1 VDD;
    supply0 GND;

    wire Q, Q_N;

    // Inverter loop
    RV523_NMOS N1(
        .S(GND),
        .D(Q),
        .G(Q_N)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(Q),
        .G(Q_N)
    );

    RV523_NMOS N2(
        .S(GND),
        .D(Q_N),
        .G(Q)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(Q_N),
        .G(Q)
    );

    // Access transistors
    RV523_NMOS N3(
        .S(BL),
        .D(Q),
        .G(WL)
    );
    RV523_NMOS N4(
        .S(BL_B),
        .D(Q_N),
        .G(WL)
    );
endmodule