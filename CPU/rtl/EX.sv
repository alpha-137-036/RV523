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
    input logic clk,
    input logic rst_n,

    // Inputs from ID stage
    input logic ex_alu_A_PC_sel,
    input logic ex_alu_B_imm_sel,
    input logic ex_load,
    input logic ex_store,
    input logic[11:0] ex_alu_op,
    input logic[31:0] ex_rs1,
    input logic[4:0]  ex_rs1_idx,
    input logic[31:0] ex_rs2,
    input logic[4:0]  ex_rs2_idx,
    input logic[4:0]  ex_rd_idx,
    input logic[31:0] ex_imm,
    input logic[31:0] ex_pc,
    input logic[31:0] ex_npc,
    
    // Inputs from MEM stage
    input logic[31:0] mem_fwd,
    
    // Inputs from the WB stage
    input logic[31:0] wb_fwd,
    
    // Output to MEM stage 
    output logic[4:0]  mem_rd_idx,
    output logic[31:0] mem_alu_out,
    output logic[31:0] mem_wdata,
    output logic[31:0] mem_branch_target,
    output logic[31:0] mem_npc,
    output logic mem_load,
    output logic mem_store,

    // Inputs from MEM stage, for hazard control
    input  logic[31:0] mem_alu_npc_out,
    
    // Inputs from the WB stage, for hazard control
    input  logic[4:0]  wb_rd_idx,
    input  logic[31:0] wb_rd
    
);
    logic[31:0] rs1_fwd, rs2_fwd, ex_wdata, alu_A, alu_B, alu_Y, ex_branch_target;
    
    // Select rs1 from ID stage or forwarded from MEM or WB stages
    always @(*) begin
        if (ex_rs1_idx == mem_rd_idx && mem_rd_idx != 0 && !mem_load) begin
            // RAW hazard, forward from MEM stage
            rs1_fwd = mem_alu_npc_out;
        end else if (ex_rs1_idx == wb_rd_idx && wb_rd_idx != 0) begin
            // RAW hazard, forward from WB stage
            rs1_fwd = wb_rd;
        end else begin
            // No RAW hazard
            rs1_fwd = ex_rs1;
        end
    end
    
    // Select rs2 from ID stage or forwarded from MEM or WB stages
    always @(*) begin
        if (ex_rs2_idx == mem_rd_idx && mem_rd_idx != 0 && !mem_load) begin
            // RAW hazard, forward from MEM stage
            rs2_fwd = mem_alu_npc_out;
        end else if (ex_rs2_idx == wb_rd_idx && wb_rd_idx != 0) begin
            // RAW hazard, forward from WB stage
            rs2_fwd = wb_rd;
        end else begin
            // No RAW hazard
            rs2_fwd = ex_rs1;
        end
    end
        
    assign ex_wdata = rs1_fwd;
  
    // Select ALU A argument from either RS1 or PC
    assign alu_A = ex_alu_A_PC_sel ? ex_pc : rs1_fwd ;
       
    // Select ALU B argument from either RS2 or IMM
    assign alu_B = ex_alu_B_imm_sel ? ex_imm : rs2_fwd;
                      
    ALU u_alu(
        .op(ex_alu_op),
        .A(alu_A),
        .B(alu_B),
        .Y(alu_Y));
        
    BranchAdder u_branch(
        .A(ex_pc),
        .B(ex_imm),
        .Y(ex_branch_target));
        
    // register and propagate to MEM stage
    always @(posedge(clk)) begin
        mem_alu_out <= alu_Y;
        mem_wdata <= ex_wdata;
        mem_branch_target <= ex_branch_target;
        mem_npc <= ex_npc;
        mem_load <= ex_load;
        mem_store <= ex_store;
        mem_rd_idx <= ex_rd_idx;
    end
    
    
    //
    //
    // TRACING
    //
    //
    always @(posedge clk) begin
        string ex_alu_op_string;
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
        `ALU_OP_SLT:  ex_alu_op_string = "SLT"; 
        `ALU_OP_SEQ:  ex_alu_op_string = "SEQ"; 
        default: ex_alu_op_string = 'X; 
        endcase
        $display("%.6f : [EX] ex_pc=%X, ex_npc=%X, ex_rs1:x%0d=%X, ex_rs2:x%0d=%X, A=%X, B=%X, ex_alu_op=%X(%s), Y=%X",
            $realtime, ex_pc, ex_npc,
            ex_rs1_idx, ex_rs1,
            ex_rs2_idx, ex_rs2,
            alu_A, alu_B, ex_alu_op, ex_alu_op_string, alu_Y);
    end
endmodule

