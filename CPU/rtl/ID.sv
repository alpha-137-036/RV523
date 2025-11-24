// All other opcodes are not used in RV32I

module ID(
    input logic clk,
    input logic rst_n,

    // Inputs from IF stage
    input logic [31:0] id_instr,
    input logic [31:0] id_pc,
    input logic [31:0] id_npc,
    
    // Outputs to the EX stage
    output logic [10:0] ex_alu_op,
    output logic [31:0] ex_imm,
    output logic [31:0] ex_rs1,
    output logic [4:0]  ex_rs1_idx,
    output logic [31:0] ex_rs2,
    output logic [4:0]  ex_rs2_idx,
    output logic [4:0]  ex_rd_idx,
    output logic [31:0] ex_pc,
    output logic [31:0] ex_npc,
    output logic        ex_alu_A_PC_sel,
    output logic        ex_alu_B_imm_sel,
    output logic        ex_load,
    output logic        ex_store,
    output logic        ex_jalr,
    output logic        ex_jalx,
    output logic        ex_bxx,
    output logic        ex_ebreak,

    // Inputs from MEM stage for branch hazards
    input  logic        if_take_branch,

    // Inputs from WB stage for RAW hazards
    input  logic [31:0] wb_rd,
    input  logic [4:0]  wb_rd_idx,

    // Output to IF stage: a stall has been detected (Load-Use Hazard)
    output logic        id_stall,

    input  logic        id_trc_bubble,
    output logic        ex_trc_bubble,
    output logic[31:0]  ex_trc_instr
    
);
    logic [31:0] id_imm, id_rs1, id_rs2;
    logic [4:0]  id_rs1_idx, id_rs2_idx, id_rd_idx;
    logic [10:0] id_alu_op;
    logic id_alu_A_PC_sel,  id_alu_B_imm_sel;
    logic id_reg_write, id_load, id_store, id_jalr, id_jalx, id_bxx, id_ebreak;

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
        `OPCODE_JALR,
        `OPCODE_SYSTEM:
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
        id_rs2_idx = opcode == `OPCODE_LOAD || opcode == `OPCODE_STORE || opcode == `OPCODE_BRANCH || opcode == `OPCODE_OP ? id_instr[24:20] : 0;

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
            case (id_instr[14:12])
            3'b000: id_alu_op = `ALU_OP_SEQ;
            3'b001: id_alu_op = `ALU_OP_SNE;
            3'b100: id_alu_op = `ALU_OP_SLT;
            3'b101: id_alu_op = `ALU_OP_SGE;
            3'b110: id_alu_op = `ALU_OP_SLTU;
            3'b111: id_alu_op = `ALU_OP_SGEU;
            default: id_alu_op = 'X;
            // TODO: bit 12 means "inverse the result"
            endcase
        endcase 
        id_load = opcode == `OPCODE_LOAD;
        id_store = opcode == `OPCODE_STORE;
        
        id_jalr = opcode == `OPCODE_JALR;
        id_jalx = opcode == `OPCODE_JALR || opcode == `OPCODE_JAL;
        id_bxx  = opcode == `OPCODE_BRANCH;
        
        id_ebreak = opcode == `OPCODE_SYSTEM && id_imm == 12'h001;
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
            ex_ebreak <= 0;
            // GOTCHA! ex_rd_idx is harmful as it can interfere with RAW hazard resolution
            ex_rd_idx <= 0;
        end else begin
            // No stall, no branch hazard: propagate the instruction control signals
            ex_load <= id_load;
            ex_store <= id_store;
            ex_jalr <= id_jalr;
            ex_jalx <= id_jalx;
            ex_bxx <= id_bxx;
            ex_ebreak <= id_ebreak;
            ex_rd_idx <= id_rd_idx;
        end
        ex_trc_bubble <= if_take_branch || id_trc_bubble || id_stall;
        ex_trc_instr <= id_instr;
    end
    
    //
    //
    // TRACING
    //
    //
    always @(posedge clk) begin
        disassemble("ID", id_pc, id_instr, id_trc_bubble);
        $display("[ ID]     rd=x%0d, rs1:x%0d=%X, rs2:x%0d=%X, imm=%X",
            id_rd_idx, id_rs1_idx, id_rs1, id_rs2_idx, id_rs2, id_imm);
    end

endmodule
