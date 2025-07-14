(* pins = "-,A,-,B1,-,B2,Y" *)
module AOI21(
    output Y,
    input A,
    input B1,
    input B2
);
    supply1 VDD;
    supply0 GND;
    wire intA, intB, intP;

    RV523_NMOS N1(
        .S(GND),
        .D(Y),
        .G(A)
    );
    RV523_NMOS N2(
        .S(GND),
        .D(intB),
        .G(B1)
    );
    RV523_NMOS N3(
        .S(intB),
        .D(Y),
        .G(B2)
    );
    RV523_PMOS P1(
        .S(intP),
        .D(Y),
        .G(A)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(intP),
        .G(B1)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(intP),
        .G(B2)
    );
endmodule