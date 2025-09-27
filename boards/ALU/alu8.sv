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
	assign nP[0] = ~(A[0] | B[0]);
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
	input [7:0] A,
	input [7:0] B,
	// input nGm8m1,
	// input nGm24m9,
	input nCin,
	output [7:0] S,
	// output nG07_o,
	// output nGm87_o,
	// output nGm24m9_o,
	// output nGm247_o
	output nCout
);
	wire [7:-1]nG;
	wire [7:-1]nP;
	
	assign nP[-1] = 1;
	assign nG[-1] = nCin;
	
	cla_generator #(.N(8)) u_cla(
		.A(A), .B(B), .nG(nG[7:0]), .nP(nP[7:0])
	);
	
	wire [8:0]nC;
	
	genvar i;
	for (i = 0; i <= 8; i++) begin
		assign nC[i] = nG[i-1] & (nP[i-1] | nCin);
	end
	for (i = 0; i < 8; i++) begin
		assign S[i] = A[i] ^ B[i] ^ ~nC[i];
	end
	assign nCout = nC[8];
	
	// wire [7:0]nGm8;

	// genvar i;
	
	// for (i = 0; i < 8; i++) begin
		// assign nGm8[i] = nG0[i] & (nP0[i] | nGm8m1);
	// end
	
	// assign nG07_o = nG0[7];
	// assign nGm87_o = nGm8[7];
	
	// genvar i;
	// for (i = 0; i < 8; i++) begin
		// assign S[i] = A[i] ^ B[i] ^ ~nG[i-1];
	// end
	
endmodule