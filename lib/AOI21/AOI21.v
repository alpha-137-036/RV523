module AOI21(
    output Y,
    input A1,
    input A2,
    input B1
);
    supply1 VDD;
    supply0 GND;

    // Adapted from https://github.com/google/skywater-pdk-libs-sky130_fd_sc_hd/blob/ac7fb61f06e6470b94e8afdf7c25268f62fbd7b1/cells/a21oi/sky130_fd_sc_hd__a21oi_1.cdl

    wire sndA1, pndA ;

    RV523_NMOS N1(
        .S(GND),
        .D(sndA1),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(sndA1),
        .D(Y),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(GND),
        .D(Y),
        .G(B1)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(pndA),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(pndA),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(pndA),
        .D(Y),
        .G(B1)
    );
endmodule