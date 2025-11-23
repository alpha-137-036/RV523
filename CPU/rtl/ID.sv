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
`define OPCODE_BUBBLE 5'bxx111

// All other opcodes are not used in RV32I

module ID(
    input logic clk,
    input logic rst_n,

    // Inputs from IF stage
    input logic [31:0] id_instr,
    input logic [31:0] id_pc,
    input logic [31:0] id_npc,
    input logic        id_bubble_tracing,
    
    // Outputs to the EX stage
    output logic [11:0] ex_alu_op,
    output logic [31:0] ex_imm,
    output logic [31:0] ex_rs1,
    output logic [4:0]  ex_rs1_idx,
    output logic [31:0] ex_rs2,
    output logic [4:0]  ex_rs2_idx,
    output logic [4:0]  ex_rd_idx,
    output logic [31:0] ex_pc,
    output logic [31:0] ex_npc,
    output logic ex_alu_A_PC_sel,
    output logic ex_alu_B_imm_sel,
    output logic ex_load,
    output logic ex_store,
    output logic ex_jalr,
    output logic ex_jalx,
    output logic ex_bxx,

    output logic ex_bubble_tracing,

    // Inputs from MEM stage for branch hazards
    input  logic if_take_branch,

    // Inputs from WB stage for RAW hazards
    input logic [31:0] wb_rd,
    input logic [4:0]  wb_rd_idx,

    // Output to IF stage: a stall has been detected (Load-Use Hazard)
    output logic id_stall
);
    logic [31:0] id_imm, id_rs1, id_rs2;
    logic [4:0]  id_rs1_idx, id_rs2_idx, id_rd_idx;
    logic [11:0] id_alu_op;
    logic id_alu_A_PC_sel,  id_alu_B_imm_sel;
    logic id_reg_write, id_load, id_store, id_jalr, id_jalx, id_bxx;

    always @(*) begin
        logic [4:0] opcode;
        opcode = id_instr[6:2];
        casex (opcode)
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

        // Selection of rs1_idx, rs2_idx, rd_idx
        id_rs1_idx = opcode == `OPCODE_LUI ? 0 : id_instr[19:15]; 
        id_rs2_idx = opcode == `OPCODE_LOAD || opcode == `OPCODE_STORE || opcode == `OPCODE_BRANCH ? id_instr[24:20] : 0;

        // If EX stage is currently executing a LOAD into a register that
        // matches one the operands, we have a Load-Use hazard
        id_stall = 0;
        if (ex_load) begin
            if (!id_alu_A_PC_sel && id_rs1_idx != 0 && ex_rd_idx == id_rs1_idx) begin
                id_stall = 1;
            end
            if (!id_alu_B_imm_sel && id_rs2_idx != 0 && ex_rd_idx == id_rs2_idx) begin
                id_stall = 1;
            end
        end
        casex (opcode) 
        default:
            id_rd_idx = id_instr[11: 7];
        `OPCODE_STORE,
        `OPCODE_BRANCH,
        `OPCODE_SYSTEM,
        `OPCODE_BUBBLE:
            // There is no "reg-write-enable" signal. Instead we use rd == 0. 
            id_rd_idx = 0;
        endcase
        // Selection of ALU operation
        case (opcode)
        default: id_alu_op = 'X;
        `OPCODE_OP,
        `OPCODE_OP_IMM: begin
            // Determined by FUNCT3 and bit 30
            case (id_instr[14:12])
            3'b000: id_alu_op = opcode == `OPCODE_OP && id_instr[30] ? `ALU_OP_SUB : `ALU_OP_ADD;
            3'b001: id_alu_op = `ALU_OP_SLL;
            3'b010: id_alu_op = `ALU_OP_SLT;
            3'b011: id_alu_op = `ALU_OP_SLTU;
            3'b100: id_alu_op = `ALU_OP_XOR;
            3'b101: id_alu_op = id_instr[30] ? `ALU_OP_SRA : `ALU_OP_SRL;
            3'b110: id_alu_op = `ALU_OP_OR;
            3'b111: id_alu_op = `ALU_OP_AND;
            endcase
        end
        `OPCODE_LUI,
        `OPCODE_AUIPC,
        `OPCODE_LOAD,
        `OPCODE_STORE,
        `OPCODE_JAL,
        `OPCODE_JALR:
            id_alu_op = `ALU_OP_ADD;
        `OPCODE_BRANCH:
            // Determined by FUNCT3
            case (id_instr[14:13])
            2'b00: id_alu_op = `ALU_OP_SEQ;
            2'b10: id_alu_op = `ALU_OP_SLT;
            2'b11: id_alu_op = `ALU_OP_SLTU;
            2'b01: id_alu_op = 'X;
            // TODO: bit 12 means "inverse the result"
            endcase
        endcase 
        id_load = opcode == `OPCODE_LOAD;
        id_store = opcode == `OPCODE_STORE;
        
        id_jalr = opcode == `OPCODE_JALR;
        id_jalx = opcode == `OPCODE_JALR || opcode == `OPCODE_JAL;
        id_bxx  = opcode == `OPCODE_BRANCH;
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
        .rd_idx(wb_rd_idx),
        .rd(wb_rd)
    );

    // register and propagate to EX stage 
    always @(posedge(clk)) begin
        if (!id_stall) begin
            ex_pc <= id_pc;
            ex_npc <= id_npc;
            ex_imm <= id_imm;
            ex_rs1 <= id_rs1;
            ex_rs1_idx <= id_rs1_idx;
            ex_rs2 <= id_rs2;
            ex_rs2_idx <= id_rs2_idx;
            ex_alu_op <= id_alu_op;
            ex_alu_A_PC_sel <= id_alu_A_PC_sel;
            ex_alu_B_imm_sel <= id_alu_B_imm_sel;
        end
        if (if_take_branch || id_stall) begin
            // Branch hazard: if branch is taken now, the instruction handed over to EX stage can be harmful
            // make it harmless by zeroizing all control lines ("bubble")
            // This is not a stall: we continue pushing new instructions

            // Other case of inserting a bubble:
            // stall because of Load-Use hazard
            ex_load <= 0;
            ex_store <= 0;
            ex_jalr <= 0;
            ex_jalx <= 0;
            ex_bxx <= 0;
            // GOTCHA! ex_rd_idx is harmful as it can interfere with RAW hazard resolution
            ex_rd_idx <= 0;
        end else begin
            // No stall, no branch hazard: propagate the instruction control signals
            ex_load <= id_load;
            ex_store <= id_store;
            ex_jalr <= id_jalr;
            ex_jalx <= id_jalx;
            ex_bxx <= id_bxx;
            ex_rd_idx <= id_rd_idx;
        end
        ex_bubble_tracing <= if_take_branch || id_bubble_tracing || id_stall;
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
        if (id_bubble_tracing) begin
            $display("    [ID] <bubble>");
        end else begin
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
    end

endmodule
