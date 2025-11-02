module cla 
#(
	parameter N = 32
)(
	input operation_t op,
	input logic [N-1:0]A,
	input logic [N-1:0]B,
    output logic [N-1:0]AG,
    output logic LT
);
    always_comb begin
        integer i;
        logic [N-1:0] a;
        a = ({N{op.add}} & A) | ({N{op.sub}} & ~A);
        logic [N-1:0] G;
        for (i = 0; i < N; i++) begin
            logic [i+1:0]S;
            S = a[i:0] + B[i:0];
            G[i] = S[i+1];
            AG[i] = a[i] ^ G[i];
        end
        LT = op.u ? G[N-1] : G[N-2];
    end
endmodule
