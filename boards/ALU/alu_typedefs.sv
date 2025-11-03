typedef struct packed {
    logic add;
	logic sub;
	logic _xor;
	logic _and;
	logic slt;
    logic sltu;
    logic seq;
    logic shift_u;
    logic rev1, rev1_n;
    logic rev2, rev2_n;
} operation_t;


`define OP_ADD  12'b101000000000
`define OP_SUB  12'b011000000000
`define OP_SEQ  12'b010000100000
`define OP_SLTU 12'b010001000000
`define OP_SLT  12'b010010000000
`define OP_SLL  12'b000000010101
`define OP_SRL  12'b000000011010
`define OP_SRA  12'b000000001010
`define OP_AND  12'b110100000000
`define OP_XOR  12'b111000000000
`define OP_OR   12'b111100000000
