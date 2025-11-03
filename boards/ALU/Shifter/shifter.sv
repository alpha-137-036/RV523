module shift_stage
#(
    parameter N = 32,
    parameter K
)(
    input  logic [N-1:0]A,
    input  logic SHIFT,
    input  logic SHIFT_N,
    input  logic FILL,
    output logic [N-1:0]Y
);
    genvar i;
    for (i = 0; i < N; i++) begin
        AOI22 u_aoi22(
            .A1(SHIFT_N), .A2(A[i]),
            .B1(SHIFT),   .B2(i < K ? FILL : A[i-K]),
            .Y(Y[i]));
        // assign Y[i] = ~((SHIFT_N & A[i]) | (SHIFT & (i < K ? FILL : A[i-K]))); 
    end
endmodule

module swapper
#(
    parameter N = 32
)(
    input  logic [N-1:0]A,
    input  logic SWAP,
    input  logic SWAP_N,
    output logic [N-1:0]Y
);  
    genvar i;
    for (i = 0; i < N; i++) begin
        // AOI22 u_aoi22(
            // .A1(SWAP_N), .A2(A[i]),
            // .B1(SWAP),   .B2(A[N-1-i]),
            // .Y(Y[i]));
        assign Y[i] = ~((SWAP_N & A[i]) | (SWAP & A[N-1-i])); 
    end
    
    // always_comb begin
        // Y = ~(({N{SWAP_N}} & A[N-1:0]) | ({N{SWAP}} & A[0:N-1]));
    // end
endmodule 

module shifter1
#(
    parameter N = 32,
    parameter K = 2
)(
    input  operation_t op,
    input  logic A0,
    input  logic [N-1:0]A,
    input  logic [K-1:0]B,
    output logic [N-1:0]F
);  
    logic [N-1:0]Fk   [K:0];
    genvar k;
    swapper u_swap_in(
        .A(A), .Y(Fk[0]),
        .SWAP(op.rev1), .SWAP_N(op.rev1_n)
    );
    for (k = 0; k < K; k++) begin
        shift_stage #(.K(1 << k)) u_stage(
            .A(Fk[k]), .Y(Fk[k+1]), 
            .SHIFT(B[k]), .SHIFT_N(~B[k]), 
            .FILL(k[0] == 0 ? ~A0 : A0)
        );
    end
    assign F = Fk[K];
endmodule

module shifter2
#(
    parameter N = 32,
    parameter K0 = 2,
    parameter K = 5
)(
    input operation_t op,
    input  logic [N-1:0]A,
    input  logic [K-1:K0]B,
    output logic [N-1:0]F,
    input  logic A0
);
    logic [N-1:0]Fk    [K:K0];
    genvar k;
    assign Fk[K0] = A;
    for (k = K0; k < K; k++) begin
        shift_stage #(.K(1 << k)) u_stage(
            .A(Fk[k]), .Y(Fk[k+1]), 
            .SHIFT(B[k]), .SHIFT_N(~B[k]), 
            .FILL(k[0] == 0 ? ~A0 : A0)
        );
    end
    swapper u_swap_out(
        .A(Fk[K]), .Y(F),
        .SWAP(op.rev2), .SWAP_N(op.rev2_n)
    );
endmodule

`ifdef XXX
module shifter
#(
    parameter N = 32,
    parameter K = 3
    
)(
    input  logic [N-1:0]A,
    input  logic [K-1:0]B,
    input  logic [K-1:0]B_N,
    output logic [N-1:0]Y
);  
    always_comb begin
        integer k;
        logic [N-1:0] X[K+1];
        X[0] = A;
        for (k = 0; k < K; k++) begin
            X[k+1] = ({N{B[k]}} & X[k]) | ({N{B_N[k]}} & (X[k] << (1 << k)));
        end
        Y = X[K];
    end
endmodule

`endif