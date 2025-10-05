module comparator_tb
#(
	parameter N = 8
)
();

    initial begin
        $dumpfile("iverilog/comparator_tb.vcd");
        $dumpvars(0);
    end

    logic [N-1:0] A, B;
    logic U;
    logic EQ;
    logic LT;
    
    comparator u_comp(
        .A(A), .B(B), .U(U), .LT(LT), .EQ(EQ)
    );

    initial begin
        A = 8'hAA;
        B = 8'hBB;
        U = 1;
        #1;
        $display("A=%x, B=%x, U=%b, EQ=%b, LT=%b", A, B, U, EQ, LT);
        assert(EQ == 0);
        assert(LT == 1);
        A = 42;
        B = 41;
        #1;
        $display("A=%x, B=%x, U=%b, EQ=%b, LT=%b", A, B, U, EQ, LT);
        assert(EQ == 0);
        assert(LT == 0);
        U = 0;
        A = -128;
        B = 4;
        #1;
        $display("A=%x, B=%x, U=%b, EQ=%b, LT=%b", A, B, U, EQ, LT);
        assert(EQ == 0);
        assert(LT == 1);
        U = 1;
        #1;
        $display("A=%x, B=%x, U=%b, EQ=%b, LT=%b", A, B, U, EQ, LT);
        assert(EQ == 0);
        assert(LT == 0);
        B = -128;
        #1;
        $display("A=%x, B=%x, U=%b, EQ=%b, LT=%b", A, B, U, EQ, LT);
        assert(EQ == 1);
        assert(LT == 0);
    end

endmodule