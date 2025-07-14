(* pins = "-,nR,-,nS,-,Q,-,nQ" *)
module SR_LATCH(
    output Q,
    output nQ,
    input nS,
    input nR,
);
    supply1 VDD;
    supply0 GND;
    wire intN1, intN2;

    RV523_NMOS N1(
        .S(GND),
        .D(intN1),
        .G(nS)
    );
    RV523_NMOS N2(
        .S(intN1),
        .D(Q),
        .G(nQ)
    );
    RV523_NMOS N3(
        .S(GND),
        .D(intN2),
        .G(nR)
    );
    RV523_NMOS N4(
        .S(intN2),
        .D(nQ),
        .G(Q)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(Q),
        .G(nS)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(Q),
        .G(nQ)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(nQ),
        .G(nR)
    );
    RV523_PMOS P4(
        .S(VDD),
        .D(nQ),
        .G(Q)
    );
endmodule