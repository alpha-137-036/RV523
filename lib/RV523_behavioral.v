module BUF(
    output Y,
    input A
);
    assign Y = A;
endmodule

module NOT(
    output Y,
    input A
);
    assign Y = !A;
endmodule

module TINV (
    output Y, 
    input  A,
    input  EN,
    input  nEN);

    always_comb begin
        if (EN && !nEN) begin
            Y <= !A;
        end
        if (EN && nEN) begin
            Y <= 'X;
        end
    end
endmodule

module NAND2(
    output Y,
    input A1,
    input A2
);
    assign Y = ~(A1 & A2);
endmodule

module AND2(
    output Y,
    input A1,
    input A2
);
    assign Y = A1 & A2;
endmodule

module NAND3(
    output Y,
    input A1,
    input A2,
    input A3
);
    assign Y = ~(A1 & A2 & A3);
endmodule

module AND3 (output Y, input A1, input A2, input A3);
    assign Y = A1 & A2 & A3;
endmodule

module NAND4(
    output Y,
    input A1,
    input A2,
    input A3,
    input A4
);
    assign Y = ~(A1 & A2 & A3 & A4);
endmodule

module AND4 (output Y, input A1, input A2, input A3, input A4);
    assign Y = A1 & A2 & A3 & A4;
endmodule

module NOR2(
    output Y,
    input A1,
    input A2,
);
    assign Y = ~(A1 | A2);
endmodule

module NOR3(
    output Y,
    input A1,
    input A2,
    input A3
);
    assign Y = ~(A1 | A2 | A3);
endmodule

module NOR4(
    output Y,
    input A1,
    input A2,
    input A3,
    input A4
);
    assign Y = ~(A1 | A2 | A3 | A4);
endmodule

module AOI21(
    output Y,
    input A,
    input B1,
    input B2
);
    assign Y = ~(A | (B1 & B2));
endmodule

module AOI22(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2
);
    assign Y = ~((A1 & A2) | (B1 & B2));
endmodule

module AOI211(
    output Y,
    input A,
    input B,
    input C1,
    input C2
);
    assign Y = ~(A | B | (C1 & C2));
endmodule

module OAI21(
    output Y,
    input A,
    input B1,
    input B2
);
    assign Y = ~(A & (B1 | B2));
endmodule

module OAI22(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2
);
    assign Y = ~((A1 | A2) & (B1 | B2));
endmodule

module OAI211(
    output Y,
    input A,
    input B,
    input C1,
    input C2
);
    assign Y = ~(A & B & (C1 | C2));
endmodule

module XOR2(
    output Y,
    input A,
    input B
);
    assign Y = A ^ B;
endmodule

module XNOR2(
    output Y,
    input A,
    input B
);
    assign Y = ~(A ^ B);
endmodule

`include "../NOT/NOT.v"
`include "../TINV/TINV.v"

// Elementary D-LATCH with complementary CLK enable inputs
module D_LATCH(
    output Q,
    output nQ,
    input D,
    input CLK,
    input nCLK
);
    always_latch begin
        if (CLK && !nCLK) begin
            Q = D;
        end
    end
endmodule

module DECAP();
endmodule

module DECAP_LED(
    input A,
    input LED_GND
);
endmodule

