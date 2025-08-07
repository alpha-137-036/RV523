`include "../D_LATCH/D_LATCH.v"

module D_FLIP_FLOP(
    output Q,
    output nQ,
    input D,
    input CLK,
    input nCLK
);
    wire Q1;
    D_LATCH master(
        .D(D),
        .CLK(nCLK),
        .nCLK(CLK),
        .Q(Q1)
    );
    D_LATCH slave(
        .D(Q1),
        .CLK(CLK),
        .nCLK(nCLK),
        .Q(Q),
        .nQ(nQ)
    );
endmodule
