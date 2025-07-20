(* pins="-,A,-,B,-,C,Y" *)
module NAND3(
    output Y,
    input A1,
    input A2,
    input A3
);
    supply1 VDD;
    supply0 GND;
    wire int1, int2;

    RV523_NMOS N1(
        .S(GND),
        .D(int1),
        .G(A1)
    );
    RV523_NMOS N2(
        .S(int1),
        .D(int2),
        .G(A2)
    );
    RV523_NMOS N3(
        .S(int2),
        .D(Y),
        .G(A3)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(Y),
        .G(A1)
    );
    RV523_PMOS P2(
        .S(VDD),
        .D(Y),
        .G(A2)
    );
    RV523_PMOS P3(
        .S(VDD),
        .D(Y),
        .G(A3)
    );
endmodule