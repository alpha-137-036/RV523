module NOR(
    output Y,
    input A,
    input B,
);
    supply1 VDD;
    supply0 GND;
    wire C;

    NMOS N1(
        .S(GND),
        .D(Y),
        .G(A)
    );
    NMOS N2(
        .S(GND),
        .D(Y),
        .G(B)
    );
    PMOS P1(
        .S(VDD),
        .D(C),
        .G(A)
    );
    PMOS P2(
        .S(C),
        .D(Y),
        .G(B)
    );
endmodule