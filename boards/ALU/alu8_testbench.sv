`timescale 1ns/1ns

module alu8_tb;
    logic [7:0]A;
    logic [7:0]B;
    logic nCin;
    wire [7:0]S;
    wire nCout;
    adder adder(
        .A(A), .B(B), .nCin(nCin), .S(S), .nCout(nCout)
    );

    always_comb begin
        $strobe("S=%d, nCout=%d", S, nCout);
    end

    initial begin
        A = 42;
        B = 232;
        nCin = 1;
        //#50ns;

    end

endmodule