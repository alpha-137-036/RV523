//
// CPU execution stage
//

module BranchAdder(
    input logic[31:0] A,
    input logic[31:0] B,
    output logic[31:0] Y
);
    assign Y = A + B;
endmodule


module EX(
    input  logic clk,
    input  logic rst_n,

    // Inputs from ID stage
    input  logic       ex_alu_A_PC_sel,
    input  logic       ex_alu_B_imm_sel,
    input  logic       ex_load,
    input  logic       ex_store,
    input  logic[2:0]  ex_size,
    input  logic       ex_jalr,
    input  logic       ex_jalx,
    input  logic       ex_bxx,
    input  logic       ex_ebreak,
    input  logic[10:0] ex_alu_op,
    input  logic[31:0] ex_rs1,
    input  logic[4:0]  ex_rs1_idx,
    input  logic[31:0] ex_rs2,
    input  logic[4:0]  ex_rs2_idx,
    input  logic[4:0]  ex_rd_idx,
    input  logic[31:0] ex_imm,
    input  logic[31:0] ex_pc,
    input  logic[31:0] ex_npc,
    
    // Output to MEM stage 
    output logic[4:0]  mem_rd_idx,
    output logic[31:0] mem_alu_out,
    output logic[31:0] mem_wdata,
    output logic[31:0] mem_npc,
    output logic       mem_load,
    output logic       mem_store,
    output logic[2:0]  mem_size,
    output logic       mem_jalr,
    output logic       mem_jalx,
    output logic       mem_bxx,
    output logic       mem_ebreak,

    // Inputs from MEM stage, for hazard control
    input  logic[31:0] mem_alu_npc_out,
    
    // Inputs from the WB stage, for hazard control
    input  logic[4:0]  wb_rd_idx,
    input  logic[31:0] wb_rd,

    // Outputs to IF stage for branching
    output logic[31:0] if_branch_target,
    output logic       if_take_branch,

    input  logic       ex_trc_bubble,
    input  logic[31:0] ex_trc_instr,
    output logic       mem_trc_bubble,
    output logic[31:0] mem_trc_pc,
    output logic[31:0] mem_trc_instr
);
    logic rs1_fwd_from_mem, rs1_fwd_from_wb;
    logic rs2_fwd_from_mem, rs2_fwd_from_wb;
    logic[31:0] rs1_fwd, rs2_fwd, ex_wdata, alu_A, alu_B, alu_Y, ex_pc_plus_imm;
    
    always @(*) begin
        // Select rs1 from ID stage or forwarded from MEM or WB stages
        rs1_fwd_from_mem = ex_rs1_idx == mem_rd_idx && mem_rd_idx != 0 && !mem_load;
        rs1_fwd_from_wb  = ex_rs1_idx == wb_rd_idx && wb_rd_idx != 0;

        rs1_fwd = rs1_fwd_from_mem ? mem_alu_npc_out : rs1_fwd_from_wb ? wb_rd : ex_rs1;

        // Select rs2 from ID stage or forwarded from MEM or WB stages
        rs2_fwd_from_mem = ex_rs2_idx == mem_rd_idx && mem_rd_idx != 0 && !mem_load;
        rs2_fwd_from_wb  = ex_rs2_idx == wb_rd_idx && wb_rd_idx != 0;
        
        rs2_fwd = rs2_fwd_from_mem ? mem_alu_npc_out : rs2_fwd_from_wb ? wb_rd : ex_rs2;

        ex_wdata = rs2_fwd;
  
        // Select ALU A argument from either RS1 or PC
        alu_A = ex_alu_A_PC_sel ? ex_pc : rs1_fwd ;
           
        // Select ALU B argument from either RS2 or IMM
        alu_B = ex_alu_B_imm_sel ? ex_imm : rs2_fwd;

        // Calculate if branch must be taken
        // Takes a bit of time after the ALU, but spares one cycle
        // for each branch misprediction
        if_branch_target = ex_jalr ? alu_Y : ex_pc_plus_imm;
        if_take_branch = ex_jalx || (ex_bxx && alu_Y[0]);

    end
    ALU u_alu(
        .op(ex_alu_op),
        .A(alu_A),
        .B(alu_B),
        .Y(alu_Y));
        
    BranchAdder u_branch(
        .A(ex_pc),
        .B(ex_imm),
        .Y(ex_pc_plus_imm));
        
    // register and propagate to MEM stage
    always @(posedge(clk)) begin
        mem_alu_out <= alu_Y;
        mem_wdata <= ex_wdata;
        mem_npc <= ex_npc;

        mem_load <= ex_load;
        mem_store <= ex_store;
        mem_jalr <= ex_jalr;
        mem_jalx <= ex_jalx;
        mem_bxx <= ex_bxx;
        mem_ebreak <= ex_ebreak;
        mem_rd_idx <= ex_rd_idx;
        mem_size <= ex_size;

        mem_trc_bubble <= ex_trc_bubble;
        mem_trc_instr <= ex_trc_instr;
        mem_trc_pc <= ex_pc;
    end
    
    
    //
    //
    // TRACING
    //
    //
    always @(posedge clk) begin
        string ex_alu_op_string;
        string A_origin, B_origin;

        disassemble("EX", ex_pc, ex_trc_instr, ex_trc_bubble);

        case (ex_alu_op)
        `ALU_OP_ADD: ex_alu_op_string = "ADD"; 
        `ALU_OP_SUB: ex_alu_op_string = "SUB"; 
        `ALU_OP_SLL: ex_alu_op_string = "SLL"; 
        `ALU_OP_SRL: ex_alu_op_string = "SRL"; 
        `ALU_OP_SRA: ex_alu_op_string = "SRA"; 
        `ALU_OP_AND: ex_alu_op_string = "AND"; 
        `ALU_OP_XOR: ex_alu_op_string = "XOR"; 
        `ALU_OP_OR:  ex_alu_op_string = "OR"; 
        `ALU_OP_SLTU: ex_alu_op_string = "SLTU"; 
        `ALU_OP_SGEU: ex_alu_op_string = "SGEU";
        `ALU_OP_SLT:  ex_alu_op_string = "SLT";
        `ALU_OP_SGE:  ex_alu_op_string = "SGE";
        `ALU_OP_SEQ:  ex_alu_op_string = "SEQ";
        `ALU_OP_SNE:  ex_alu_op_string = "SNE";
        default: ex_alu_op_string = 'X;
        endcase
        if (ex_alu_A_PC_sel) A_origin = "pc";
        else if (rs1_fwd_from_mem) A_origin = "mem";
        else if (rs1_fwd_from_wb) A_origin = "wb";
        else A_origin = "id";
        if (ex_alu_B_imm_sel) B_origin = "imm";
        else if (rs2_fwd_from_mem) B_origin = "mem";
        else if (rs2_fwd_from_wb) B_origin = "wb";
        else B_origin = "id";
        $display("[ EX]     A=%X(%s), B=%X(%s), ex_alu_op=%X(%s), Y=%X",
            alu_A, A_origin,
            alu_B, B_origin,
            ex_alu_op, ex_alu_op_string, alu_Y);
        if (if_take_branch) begin
            $display("[ EX]     branch to %X", if_branch_target);
        end else if (mem_bxx) begin
            $display("[ EX]     branch not taken");
        end

    end
endmodule

