module alu32(
	input  [31:0]A,
	input  [31:0]B,
	output [31:0]S,
	output nCout);
	
	// wire nG0_7;
	// wire nG8_15;
	// wire nG16_23;
	// wire nG24_31;
	
	// wire nG0_15;
	// wire nG8_23;
	// wire nG16_31;
	
	wire nG0_7, nG8_15, nG16_23, nG24_31;

	alu8 u_0_7(
		.A(A[7:0]), .B(B[7:0]), .S(S[7:0]),
		.nCin(1'b1), .nCout(nG0_7)
	);
	alu8 u_8_15(
		.A(A[15:8]), .B(B[15:8]), .S(S[15:8]), 
		.nCin(nG0_7), .nCout(nG8_15)
	);
	alu8 u_16_23(
		.A(A[23:16]), .B(B[23:16]), .S(S[23:16]),
		.nCin(nG8_15), .nCout(nG16_23)
	);
	alu8 u_24_31(
		.A(A[31:24]), .B(B[31:24]), .S(S[31:24]),
		.nCin(nG16_23), .nCout(nCout)
	);
	
	// alu8 u_0_7(
		// .A(A[7:0]), .B(B[7:0]), .S(S[7:0]),
		// .nGm8m1(0), .nGm24m9(0),
		// .nG07_o(nG0_7)
	// );
	// alu8 u_8_15(
		// .A(A[15:8]), .B(B[15:8]), .S(S[15:8]), 
		// nGm8m1(nG0_7), .nGm24m9(0)
		// .nG07_o(nG8_15),
		// .nGm87_o(nG0_15),
	// );
	// alu8 u_16_23(
		// .A(A[23:16]), .B(B[23:16]), .S(S[23:16]),
		// nGm8m1(nG8_15), .nGm24m9(nG0_7)
		// .nG07_o(nG16_23)
	// );
	// alu8 u_24_31(
		// .A(A[31:24]), .B(B[31:24]), .S(S[31:24]),
		// nGm8m1(nG16_23), .nGm24m9(nG0_15)
		// .nG07_o(nG24_31)
	// );
endmodule