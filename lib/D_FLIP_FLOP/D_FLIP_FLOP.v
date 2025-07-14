module D_FLIP_FLOP(
    output Q,
    output nQ,
    input D,
    input EN,
    input nEN
);
    wire Q1;
    D_LATCH master(
        .D(D),
        .EN(nEN),
        .nEN(EN),
        .Q(Q1)
    );
    D_LATCH slave(
        .D(Q1),
        .EN(EN),
        .nEN(nEN),
        .Q(Q),
        .nQ(nQ)
    );
endmodule
