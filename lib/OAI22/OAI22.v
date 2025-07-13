(* pins = "-,A1,-,A2,-,B1,-,B2,Y" *)
module OAI22(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2
);
    supply1 VDD;
    supply0 GND;
    wire intA, intB, intN;

    RV523_NMOS N1(
        .S(GND),
        .D(intN),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(GND),
        .D(intN),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(intN),
        .D(Y),
        .G(B1)
    );
    RV523_NMOS N4(
        .S(intN),
        .D(Y),
        .G(B2)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(intA),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(intA),
        .D(Y),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(intB),
        .G(B1)
    );
    RV523_PMOS P4(
        .S(intB),
        .D(Y),
        .G(B2)
    );
endmodule