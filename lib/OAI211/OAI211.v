(* pins = "-,A,-,B,-,C1,-,C2,Y" *)
module OAI211(
    output Y,
    input A,
    input B,
    input C1,
    input C2
);
    supply1 VDD;
    supply0 GND;
    wire intC, intNA, intNB;

    RV523_NMOS N1(
        .S(GND),
        .D(intNA),
        .G(A)
    );
    RV523_NMOS N2(
        .S(intNA),
        .D(intNB),
        .G(B)
    );
    RV523_NMOS N3(
        .S(intNB),
        .D(Y),
        .G(C1)
    );
    RV523_NMOS N4(
        .S(intNB),
        .D(Y),
        .G(C2)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(Y),
        .G(A)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(Y),
        .G(B)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(intC),
        .G(C1)
    );
    RV523_PMOS P4(
        .S(intC),
        .D(Y),
        .G(C2)
    );
endmodule