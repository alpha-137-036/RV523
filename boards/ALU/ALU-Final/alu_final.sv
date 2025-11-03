// module isZero
// #(
    // parameter N = 32
// )
// (
    // input logic [N-1:0]A,
    // output logic ZERO
// );
    // assign ZERO = A == 0;
// endmodule

module alu_final
#(
    parameter N = 32
)
(
    input  operation_t op,
    input  logic [N-1:0]A,
    input  logic [N-1:0]B,
    input  logic G31,
    input  logic [N-1:0]F,
    output logic [N-1:0]Y,
    output logic A0
);
    always_comb begin
        Y = ~F;
        if (op.seq)  Y[0] |= (A ^ B) == 0;
        if (op.slt)  Y[0] |= A[N-1] ^ B[N-1];
        if (op.sltu) Y[0] |= G31;
        if (op._xor) Y |= A ^ B;
        if (op._and) Y |= A & B;
    end
    assign A0 = op.shift_u ? 1'b0 : A[N-1];
endmodule