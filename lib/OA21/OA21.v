`include "../OAI21/OAI21.v"
`include "../NOT/NOT.v"

module OA21(
    output Y,
    input A,
    input B1,
    input B2
);
    wire Y_N;

    OAI21 oai(.A(A), .B1(B1), .B2(B2), .Y(Y_N));
    NOT  not1(.A(Y_N), .Y(Y));
endmodule