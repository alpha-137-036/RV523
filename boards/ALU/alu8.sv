module cla_generator
#(
	parameter N = 8
)(
	input operation_t op,
	input logic [N-1:0]A,
	input logic [N-1:0]B,
	output logic [N-1:0]nG,
	output logic [N-1:0]nP
);
if (N == 1) begin
	always_comb begin
		if (op.sub) begin
			// 0 1 => generate
			// 0 0 or 1 1 => propagate
			// 1 0 => neither propagate nor generate
			nG[0] = ~(~A[0] & B[0]);
			nP[0] = ~(~A[0] | B[0]);
		end else begin
			// 1 1 => generate
			// 1 0 or 0 1 => propagate
			// 0 0 => neither propagate nor generate
			nG[0] = ~(A[0] & B[0]);
			nP[0] = ~(A[0] | B[0]);
		end
	end
end else begin
	parameter K = N/2;
	wire [N-1:K]nGh, nPh;

	cla_generator #(.N(K)) u_low(
		.op(op),
		.A(A[K-1:0]),
		.B(B[K-1:0]),
		.nG(nG[K-1:0]),
		.nP(nP[K-1:0])
	);

	cla_generator #(.N(N-K)) u_high(
		.op(op),
		.A(A[N-1:K]),
		.B(B[N-1:K]),
		.nG(nGh[N-1:K]),
		.nP(nPh[N-1:K])
	);
	
	integer i;
	always_comb begin
		for (i = K; i < N; i++) begin
			nP[i] = nPh[i] | nP[K-1];
			nG[i] = nGh[i] & (nPh[i] | nG[K-1]);
		end
	end
end	

endmodule

module alu8
(
	input operation_t op,
	input  logic [7:0] A,
	input  logic [7:0] B,
	input  logic [3:0] north,
	output logic [7:0] S,
	output logic [3:0] south
);
	integer i;

	logic [7:-1] nG0;
	logic [7:-1] nP0;
	logic [7:-1]nGm24;

	logic nGm8m1, nGm16m1, nGm24m1, nGm32m1, nG07, nGm87, nGm167, nGm247;
	
	assign { nGm8m1, nGm16m1, nGm24m1, nGm32m1 } = north;
	
	cla_generator #(.N(8)) u_cla(
		.op(op),
		.A(A), .B(B), .nG(nG0[7:0]), .nP(nP0[7:0])
	);

	always_comb begin
		nG07    = nG0[7];
		nGm87   = nG07 & (nP0[7] | nGm8m1);
		nGm167  = nG07 & (nP0[7] | nGm16m1);
		nG0[-1] = 1'b1;
		nP0[-1] = 1'b1;
		nGm24[-1] = nGm24m1;

		for (i = 0; i < 8; i++) begin
			nGm24[i] = nG0[i] & (nP0[i] | nGm24m1);
			if (op._xor) begin
				S[i] = A[i] ^ B[i];
			end else if (op._and) begin
				S[i] = A[i] & B[i];
			end else begin 
				S[i] = A[i] | B[i];
			end
			if (op.set0) begin
				S[i] = op.bit0;
			end
			if (op.carry) begin
				S[i] = S[i] ^ ~nGm24[i-1];
			end
		end
		nGm247  = nGm24[7];
	end
	
	assign south = { nG07, nGm87, nGm167, nGm247};
	
endmodule