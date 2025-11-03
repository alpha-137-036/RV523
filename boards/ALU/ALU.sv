module ALU
#(
    parameter N = 32
)
(
    input operation_t op,
    input logic [N-1:0]A,
    input logic [N-1:0]B,
    output logic [N-1:0]Y
);
    logic [N-1:0] BG;
    logic [N-1:0] S;
    logic G31;
    cla u_cla(
        .op(op), 
        .A(A), .B(B),
        .BG(BG),
        .G31(G31)
    );
    
    alu_final u_final(
        .op(op),
        .A(A),
        .B(BG),
        .G31(G31),
        .SHIFT(S),
        .Y(Y));

    logic S0;
    logic [N-1:0]Y3;
    shifter1 u_shift1(
        .A(A), .B(B[1:0]), .op(op), .S0(S0), .Y(Y3)
    );
    
    shifter2 u_shift2(
        .A(Y3), .B(B[4:2]), .op(op), .S0(S0), .Y(S)
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