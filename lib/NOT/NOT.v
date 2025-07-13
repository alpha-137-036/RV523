module NOT(
    output Y,
    input A
);
    supply1 VDD;
    supply0 GND;

    NMOS N1(
        .S(GND),
        .D(Y),
        .G(A)
    );
    PMOS P1(
        .S(VDD),
        .D(Y),
        .G(A)
    );
endmodule