`define OPCODE_LOAD   5'b00000
`define OPCODE_STORE  5'b01000
`define OPCODE_BRANCH 5'b11000
`define OPCODE_JALR   5'b11001
`define OPCODE_JAL    5'b11011
`define OPCODE_OP_IMM 5'b00100
`define OPCODE_OP     5'b01100
`define OPCODE_AUIPC  5'b00101
`define OPCODE_LUI    5'b01101
`define OPCODE_SYSTEM 5'b11100

// All other opcodes are not used in RV32I

module ID(
    input logic clk,
    input logic rst_n,

    // Inputs from IF stage
    input logic [31:0] id_instr,
    input logic [31:0] id_pc,
    input logic [31:0] id_npc,
    
    // Inputs from control logic 
    input logic [31:0] id_wdata,
    input logic [4:0]  id_wrd_idx,
    input logic        id_write,
    
    // Outputs to the control logic 
    output logic [4:0]  id_rs1_idx,
    output logic [4:0]  id_rs2_idx,
    output logic [4:0]  id_rd_idx,
   
    // Outputs to the EX stage
    output logic [31:0] ex_imm,
    output logic [31:0] ex_rs1,
    output logic [31:0] ex_rs2,
    output logic [31:0] ex_pc,
    output logic [31:0] ex_npc,
    output logic ex_alu_A_PC_sel,
    output logic ex_alu_B_imm_sel
);
    logic [31:0] id_imm, id_rs1, id_rs2;
    logic id_alu_A_PC_sel,  id_alu_B_imm_sel;
    
    always @(*) begin
        logic [4:0] opcode;
        opcode = id_instr[6:2];
        case (opcode)
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
        id_alu_A_PC_sel = opcode == `OPCODE_AUIPC || opcode == `OPCODE_JAL;
        id_alu_B_imm_sel = opcode != `OPCODE_OP && opcode != `OPCODE_BRANCH;
    end

    // Selection of rs1_idx, rs2_idx, rd_idx
    always @(*) begin
        if (id_instr[6:2] == `OPCODE_LUI) begin
            // Simplest way to get 0 as rs1 
            id_rs1_idx = 0; 
        end else begin
            id_rs1_idx = id_instr[19:15];
        end
        id_rs2_idx = id_instr[24:20];
        id_rd_idx  = id_instr[11: 7];
    end
    
    // 
    // Get the registers rs1 and rs2
    // and perform the write
    //
    Regs u_regs(
        .clk(clk),
        .rs1_idx(id_rs1_idx),
        .rs2_idx(id_rs2_idx),
        .rs1(id_rs1),
        .rs2(id_rs2),
        .rd_idx(id_wrd_idx),
        .write(id_write),
        .rd(id_wdata)
    );

    // register and propagate to EX stage 
    always @(posedge(clk)) begin
        ex_pc <= id_pc;
        ex_npc <= id_npc;
        ex_imm <= id_imm;
        ex_rs1 <= id_rs1;
        ex_rs2 <= id_rs2;
        ex_alu_A_PC_sel <= id_alu_A_PC_sel;
        ex_alu_B_imm_sel <= id_alu_B_imm_sel;
    end
    
    //
    //
    // TRACING
    //
    //
    always @(posedge clk) begin
        $display("%.6f : [ID] id_pc=%X, id_npc=%X, id_instr=%X, id_imm=%X, id_rs1:x%0d=%X, id_rs2:x%0d=%X, id_rd=x%0d",
            $realtime, id_pc, id_npc, id_instr, id_imm, 
            id_rs1_idx, id_rs1, id_rs2_idx, id_rs2, id_rd_idx);

        // Disassembly
        case (id_instr[6:2])
        `OPCODE_AUIPC:
            $display("    %X: %X auipc x%0d, 0x%0X", id_pc, id_instr, id_rd_idx, id_imm);
        `OPCODE_LUI:
            $display("    %X: %X: lui x%0d, 0x%0X", id_pc, id_instr, id_rd_idx, id_imm);
        `OPCODE_OP_IMM,
        `OPCODE_OP: begin
            string op;
            case (id_instr[14:12])
                3'd0: op = id_instr[6:2] == `OPCODE_OP && id_instr[30] ? "sub" : "add";
                3'd4: op = "xor";
                3'd6: op = "or";
                3'd7: op = "and";
                3'd1: op = "sll";
                3'd5: op = id_instr[30] ? "sra" : "srl";
                3'd2: op = "slt";
                3'd3: op = "sltu";
            endcase
            if (id_instr[6:2] == `OPCODE_OP) begin
                $display("    %X: %X: %s x%0d, x%0d, x%0d", id_pc, id_instr, op, id_rd_idx, id_rs1_idx, id_rs2_idx);
            end else begin
                $display("    %X: %X: %si x%0d, x%0d, 0x%0X", id_pc, id_instr, op, id_rd_idx, id_rs1_idx, id_imm);
            end
        end
        `OPCODE_LOAD: begin
            string op;
            case (id_instr[14:12])
                3'd0: op = "lb";
                3'd1: op = "lh";
                3'd2: op = "lw";
                3'd4: op = "lbu";
                3'd5: op = "lhu";
                default: op = "l??";
            endcase
            $display("    %X: %X: %s x%0d, 0x%0X(x%0d)", id_pc, id_instr, op, id_rd_idx, id_imm, id_rs1_idx);
        end
        `OPCODE_STORE: begin
            string op;
            case (id_instr[14:12])
                3'd0: op = "sb";
                3'd1: op = "sh";
                3'd2: op = "sw";
                default: op = "s??";
            endcase
            $display("    %X: %X: %s x%0d, 0x%0X(x%0d)", id_pc, id_instr, op, id_rs2_idx, id_imm, id_rs1_idx);
        end
        `OPCODE_BRANCH: begin
            string op;
            case (id_instr[14:12])
                3'd0: op = "beq";
                3'd1: op = "bne";
                3'd4: op = "blt";
                3'd5: op = "bge";
                3'd6: op = "bltu";
                3'd6: op = "bgeu";
                default: op = "b??";
            endcase
            $display("    %X: %X: %s x%0d, x%0d, 0x%0X", id_pc, id_instr, op, id_rs1_idx, id_rs2_idx, id_pc + id_imm);
        end
        `OPCODE_JAL:
            $display("    %X: %X: jal x%0d, 0x%0X", id_pc, id_instr, id_rd_idx, id_pc + id_imm);
        `OPCODE_JALR:
            $display("    %X: %X: jalr x%0d, 0x%0X(x%0d)", id_pc, id_instr, id_rd_idx, id_imm, id_rs1_idx);
        `OPCODE_SYSTEM: begin
            string op;
            case (id_instr[31:20])
                12'd0: op = "ecall";
                12'd1: op = "ebreak";
                default: op = "system-??";
            endcase
            $display("    %X: %X: %s", id_pc, id_instr, op);
        end
        default:
            $display("    %X: %X: ???", id_pc, id_instr);
        endcase
    end

endmodule
