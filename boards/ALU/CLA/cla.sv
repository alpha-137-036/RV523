module cla 
#(
	parameter N = 32
)(
	input operation_t op,
	input logic [N-1:0]A,
	input logic [N-1:0]B,
    output logic [N-1:0]BG,
    output logic G31
);
    logic [N-1:0] a;
    logic [N-1:0] G;
    genvar i;
    for (i = 0; i < N; i++) begin
        // AOI22 u_a(
            // .A1(op.add), .A2(~A[i]),
            // .B1(op.sub), .B2(A[i]),
            // .Y(a[i]));
         assign a[i] = ~((op.add & ~A[i]) | (op.sub & A[i]));
    end
    for (i = 0; i < N; i++) begin
        logic [i+1:0]S;
        assign S = a[i:0] + B[i:0];
        assign G[i] = S[i+1];
        assign BG[i] = B[i] ^ ( i == 0 ? 0 : G[i-1]);
    end
    assign G31 = G[N-1];
    
    // assign BG = (a + B) ^ A;
endmodule
