`define OPCODE_LOAD   5'b00000
`define OPCODE_STORE  5'b01000
`define OPCODE_BRANCH 5'b11000
`define OPCODE_JALR   5'b11001
`define OPCODE_JAL    5'b11011
`define OPCODE_OP_IMM 5'b00100
`define OPCODE_OP     5'b01100
`define OPCODE_AUIPC  5'b00101
`define OPCODE_LUI    5'b01101

// All other opcodes are not used in RV32I

module ID(
    input logic clk,
    input logic rst_n,

    // Inputs from IF stage
    input logic [31:0] id_instr,
    input logic [31:0] id_pc,
    input logic [31:0] id_npc 
);
    logic [31:0] id_imm;
    always_comb begin
        case (id_instr[6:2])
        default:
            // no immediate. imm is dont-care
            id_imm = 'X;
        `OPCODE_AUIPC,
        `OPCODE_LUI:
            // U format
            id_imm = {id_instr[31:12],12'b0};
        `OPCODE_LOAD,
        `OPCODE_OP_IMM,
        `OPCODE_JALR:
            // I format
            id_imm = {{20{id_instr[31]}},id_instr[31:20]};
        `OPCODE_STORE:
            // S format
            id_imm = {{20{id_instr[31]}},id_instr[31:25],id_instr[11:7]};
        `OPCODE_BRANCH:
            // B format
            id_imm = {{20{id_instr[31]}},id_instr[7],id_instr[30:25],id_instr[11:8],1'b0};
        `OPCODE_JAL:
            // J format
            id_imm = {{12{id_instr[31]}},id_instr[19:12],id_instr[20],id_instr[30:21],1'b0};      
        endcase
    end



    // TRACING
    always @(posedge clk) begin
        $strobe("%.6f : [ID] id_pc=%X, id_npc=%X, id_instr=%X, id_imm=%X", $realtime, id_pc, id_npc, id_instr, id_imm);
    end

endmodule
