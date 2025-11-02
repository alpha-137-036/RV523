module alu_final
#(
    parameter N = 32
)
(
    input  operation_t op,
    input  logic [N-1:0]A,
    input  logic [N-1:0]B,
    input  logic LT,
    input  logic [N-1:0]SHIFT,
    output logic [N-1:0]Y,
    output logic EQ
);

    always_comb begin
        Y = SHIFT;
        if (op._xor) Y |= ~A ^ B;
        if (op._and) Y |= ~A & B;
        if (op.set0) Y |= LT;
        EQ = Y == 0;
    end

endmodule