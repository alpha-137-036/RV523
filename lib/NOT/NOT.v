(* pins = "-,A,Y" *)
module NOT(
    output Y,
    input A
);
    supply1 VDD;
    supply0 GND;

    RV523_NMOS N1(
        .S(GND),
        .D(Y),
        .G(A)
    );
    RV523_PMOS P1(
        .S(VDD),
        .D(Y),
        .G(A)
    );
endmodule