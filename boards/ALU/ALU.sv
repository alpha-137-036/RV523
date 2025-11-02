module ALU
#(
    parameter N = 32
)
(
    input operation_t op,
    input logic [N-1:0]A,
    input logic [N-1:0]B,
    output logic [N-1:0]Y,
    output logic LT,
    output logic EQ
);
    logic LT;
    logic [N-1:0] AG;
    logic [N-1:0] S;
    cla u_cla(
        .op(op), 
        .A(A), .B(B),
        .AG(AG),
        .LT(LT)
    );
    
    alu_final u_final(
        .op(op),
        .A(AG),
        .B(B),
        .SHIFT(S),
        .LT(LT),
        .Y(Y),
        .EQ(EQ));

    logic S0;
    logic [N-1:0]Y3;
    shifter1 u_shift1(
        .A(A), .B(B[2:0]), .op(op), .SIGNED(SIGNED), .S0(S0), .Y(Y3)
    );
    
    shifter2 u_shift2(
        .A(Y3), .B(B[4:3]), .op(op), .SIGNED(SIGNED), .S0(S0), .Y(S)
    );

endmodule


`ifdef XXX
module shifter
#(
    parameter K = 5,
    parameter N = 1 << K
)
(
    input logic [N-1:0]A,
    input logic [K-1:0]B,
    input logic SWAP,
    input logic SWAP_N,
    input logic SIGNED,
    output logic [N-1:0]Y
);
    logic S0;
    logic [N-1:0]Y3;
    shifter1 u_shift1(
        .A(A), .B(B[2:0]), .SWAP(SWAP), .SWAP_N(SWAP_N), .SIGNED(SIGNED), .S0(S0), .Y(Y3)
    );
    
    shifter2 u_shift2(
        .A(Y3), .B(B[4:3]), .SWAP(SWAP), .SWAP_N(SWAP_N), .SIGNED(SIGNED), .S0(S0), .Y(Y)
    );

endmodule

`endif