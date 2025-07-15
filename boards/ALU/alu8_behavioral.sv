module adder(
    input [7:0]A,
    input [7:0]B,
    input nCin,
    output [7:0]S,
    output nCout
);
    wire [8:0] FullS;
    assign FullS = {1'b0, A} + {1'b0, B} + {8'b0, nCin};
    assign nCout = FullS[8];
    assign S = FullS[7:0];
endmodule