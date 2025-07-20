(* pins = "A1,-,A2,Y" *)
module NOR2(
    output Y,
    input A1,
    input A2,
);
    supply1 VDD;
    supply0 GND;
    wire C;

    RV523_NMOS N1(
        .S(GND),
        .D(Y),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(GND),
        .D(Y),
        .G(A2)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(C),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(C),
        .D(Y),
        .G(A2)
    );
endmodule