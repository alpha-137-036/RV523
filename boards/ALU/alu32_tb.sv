module alu32_tb();
	operation_t op;
	logic [31:0]A, B, S;
	logic nCout;

	alu32 u_alu(
		.op(op),
		.A(A), .B(B), .S(S), .nCout(nCout)
	);


	initial begin
		$dumpfile("alu32_tb.vcd");
		$dumpvars(0, u_alu);
	end

	initial begin
		op.carry_propagate = 1;
		A = 32'h444FFFCF;
		B = 32'h00000001;
		#1;
		A = 32'h444FFFFF;
		B = 32'h00000001;
		#1;
		A = 32'h80000000;
		B = 32'h7FFFFFFF;
		#1;
		A = 32'h80000000;
		B = 32'h80000000;
		#1;
		A = 32'h1234FFFF;
		B = 32'h00000001;
		#1;
	end
	
endmodule