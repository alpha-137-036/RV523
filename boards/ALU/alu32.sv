module alu32(
	input operation_t op,
	input  [31:0]A,
	input  [31:0]B,
	output [31:0]S,
	output nCout
);
	wire [3:0]port0, port1, port2, port3, port4;
	
	assign port0 = 4'b1111;
	
	alu8 u_0_7(
		.op(op),
		.A(A[7:0]), 
		.B(B[7:0]), 
		.S(S[7:0]),
		.north(port0),
		.south(port1)
	);
	alu8 u_8_15(
		.op(op),
		.A(A[15:8]), 
		.B(B[15:8]), 
		.S(S[15:8]), 
		.north(port1),
		.south(port2)
	);
	alu8 u_16_23(
		.op(op),
		.A(A[23:16]), 
		.B(B[23:16]), 
		.S(S[23:16]),
		.north(port2),
		.south(port3)
	);
	alu8 u_24_31(
		.op(op),
		.A(A[31:24]), 
		.B(B[31:24]), 
		.S(S[31:24]),
		.north(port3),
		.south(port4)
	);

	assign nCout = port4[0];
	
	assign op.bit0 = nCout;

endmodule