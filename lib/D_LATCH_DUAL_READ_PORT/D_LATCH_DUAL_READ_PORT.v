
// Elementary D-LATCH with complementary CLK inputs
// and two tristate read ports
module D_LATCH_DUAL_READ_PORT(
    input D,
    input CLK,
    input nCLK,
    output Q,
    input EN1,
    input nEN1,
    input EN2,
    input nEN2,
    output Q1,
    output Q2,
);
    wire nQ;
    D_LATCH latch(
        .D(D),
        .CLK(CLK),
        .nCLK(nCLK),
        .Q(Q),
        .nQ(nQ)
    );
    TINV port1(
        .A(nQ),
        .EN(EN1),
        .nEN(nEN1),
        .Y(Q1)
    );
    TINV port2(
        .A(nQ),
        .EN(EN2),
        .nEN(nEN2),
        .Y(Q2)
    );
endmodule