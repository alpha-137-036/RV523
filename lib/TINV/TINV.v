// Tristate inverter
module TINV(
    output Y,
    input  A,
    input  EN,
    input  nEN
);
    supply1 VDD;
    supply0 GND;
    wire intN, intP;
    RV523_NMOS N1(
        .S(GND),
        .G(A),
        .D(intN),
    );
    RV523_NMOS N2(
        .S(intN),
        .G(EN),
        .D(Y),
    );
    RV523_PMOS P1(
        .S(VDD),
        .G(A),
        .D(intP),
    );
    RV523_PMOS P2(
        .S(intP),
        .G(nEN),
        .D(Y),
    );
endmodule
