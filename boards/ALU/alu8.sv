module fulladder(
    input A,
    input B,
    input nCin,
    output S,
    output nCout
);
    wire nA, nB, Cin;
    wire AxB, nAxB;

    NOT XnA (nA, A);
    NOT XnB (nB, B);
    NOT XCin (Cin, nCin);

    AOI22 XAxB (AxB, A, B, nA, nB);
    NOT XnAxB (nAxB, AxB);

    AOI22 XS (S, nAxB, nCin, AxB, Cin);

    AOI22 XnCout (nCout, A, B, Cin, AxB);    
endmodule

module adder(
    input [7:0]A,
    input [7:0]B,
    input nCin,
    output [7:0]S,
    output nCout
);
    genvar i;
    wire [7:-1] nC;
    assign nC[-1] = nCin;
    assign nCout = nC[7];
    for (i = 0; i < 8; i++) begin
        fulladder FA(.A(A[i]), .B(B[i]), .nCin(nC[i-1]), .S(S[i]), .nCout(nC[i]));
    end
endmodule 
