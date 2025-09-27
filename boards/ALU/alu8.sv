module cla_generator
#(
	parameter N = 8
)(
	input [N-1:0]A,
	input [N-1:0]B,
	output [N-1:0]nG,
	output [N-1:0]nP
);
if (N == 1) begin
	assign nG[0] = ~(A[0] & B[0]);
	assign nP[0] = ~(A[0] ^ B[0]);
end else begin
	parameter K = N/2;
	wire [N-1:K]nGh, nPh;

	cla_generator #(.N(K)) u_low(
		.A(A[K-1:0]),
		.B(B[K-1:0]),
		.nG(nG[K-1:0]),
		.nP(nP[K-1:0])
	);

	cla_generator #(.N(N-K)) u_high(
		.A(A[N-1:K]),
		.B(B[N-1:K]),
		.nG(nGh[N-1:K]),
		.nP(nPh[N-1:K])
	);
	
	genvar i;
	for (i = K; i < N; i++) begin
		assign nP[i] = nPh[i] | nP[K-1];
		assign nG[i] = nGh[i] & (nPh[i] | nG[K-1]);
	end
end	

endmodule

module alu8
(
	input  [7:0] A,
	input  [7:0] B,
	input  [3:0] north,
	output [7:0] S,
	output [3:0] south
);
	genvar i;

	wire [7:-1] nG0;
	wire [7:-1] nP0;

	wire nGm8m1, nGm16m1, nGm24m1, nGm32m1, nG07, nGm87, nGm167, nGm247;
	
	assign { nGm8m1, nGm16m1, nGm24m1, nGm32m1 } = north;
	
	cla_generator #(.N(8)) u_cla(
		.A(A), .B(B), .nG(nG0[7:0]), .nP(nP0[7:0])
	);

	assign nG07    = nG0[7];
	assign nGm87   = nG07 & (nP0[7] | nGm8m1);
	assign nGm167  = nG07 & (nP0[7] | nGm16m1);
	assign nG0[-1] = 1'b1;
	assign nP0[-1] = 1'b1;
	wire [7:-1]nGm24;
	assign nGm24[-1] = nGm24m1;


	for (i = 0; i < 8; i++) begin
		assign nGm24[i] = nG0[i] & (nP0[i] | nGm24m1);
		assign S[i]     = A[i] ^ B[i] ^ ~nGm24[i-1];
	end
	assign nGm247  = nGm24[7];
	
	assign south = { nG07, nGm87, nGm167, nGm247};
	
endmodule