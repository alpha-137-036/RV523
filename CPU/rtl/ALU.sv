

module ALU(
    input  logic[11:0] op,
    input  logic[31:0] A,
    input  logic[31:0] B,
    output logic[31:0] Y
);
    always @(*) begin
        case(op)
            `ALU_OP_ADD: Y = A + B; 
            `ALU_OP_SUB: Y = A - B; 
            `ALU_OP_SLL: Y = A << B[4:0]; 
            `ALU_OP_SRL: Y = A >> B[4:0]; 
            `ALU_OP_SRA: Y = $signed(A) >>> B[4:0];
            `ALU_OP_AND: Y = A & B;
            `ALU_OP_XOR: Y = A ^ B;
            `ALU_OP_OR:  Y = A | B;
            `ALU_OP_SLTU: Y = {31'b0, A < B};
            `ALU_OP_SLT:  Y = {31'b0, $signed(A) < $signed(B)};
            `ALU_OP_SEQ:  Y = {31'b0, A == B};
            default:  Y = 'X;
        endcase
    end
endmodule