(* pins = "-,A,B,-,Y" *)
module NAND(
    output Y,
    input A,
    input B
);
    supply1 VDD;
    supply0 GND;
    wire int1;

    RV523_NMOS N1(
        .S(GND),
        .D(int1),
        .G(A)
    );
    RV523_NMOS N2(
        .S(int1),
        .D(Y),
        .G(B)
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
endmodule