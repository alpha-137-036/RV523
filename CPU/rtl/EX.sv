//
// CPU execution stage
//
module select3(
    input logic[1:0] sel,
    input logic[31:0] in0,
    input logic[31:0] in1,
    input logic[31:0] in2,
    output logic[31:0] out
);
    always_comb begin
        case (sel)
            2'b00: out = in0; 
            2'b01: out = in1;
            2'b11: out = in2;
            default: out = 'X;
        endcase
    end
endmodule

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
    input logic ex_reg_write,
    input logic ex_load,
    input logic ex_store,
    input logic[11:0] ex_alu_op,
    input logic[31:0] ex_rs1,
    input logic[31:0] ex_rs2,
    input logic[31:0] ex_imm,
    input logic[31:0] ex_pc,
    input logic[31:0] ex_npc,
    
    // Inputs from MEM stage
    input logic[31:0] mem_fwd,
    
    // Inputs from the WB stage
    input logic[31:0] wb_fwd,
    
    // Inputs from the control/hazard units
    input logic [1:0] ex_rs1_fwd_sel,
    input logic [1:0] ex_rs2_fwd_sel,
    
    // Output to MEM stage 
    output logic[31:0] mem_alu_out,
    output logic[31:0] mem_wdata,
    output logic[31:0] mem_branch_target,
    output logic[31:0] mem_npc,
    output logic mem_reg_write,
    output logic mem_load,
    output logic mem_store
);
    logic[31:0] rs1_fwd, rs2_fwd, wdata, alu_A, alu_B, alu_Y, ex_branch_target;
    
    // Select rs1 from ID stage or forwarded from MEM or WB stage
    select3 u_sel_rs1(
        .sel(ex_rs1_fwd_sel),
        .in0(ex_rs1),
        .in1(mem_fwd),
        .in2(wb_fwd),
        .out(rs1_fwd));
        
    assign wdata = rs1_fwd;
  
    // Select ALU A argument from either RS1 or PC
    assign alu_A = ex_alu_A_PC_sel ? ex_pc : rs1_fwd ;
       
    // Select RS2 from ID stage or forwarded from MEM or WB stage
    select3 u_sel_rs2(
        .sel(ex_rs2_fwd_sel),
        .in0(ex_rs2),
        .in1(mem_fwd),
        .in2(wb_fwd),
        .out(rs2_fwd));
       
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
        mem_wdata <= wdata;
        mem_branch_target <= ex_branch_target;
        mem_npc <= ex_npc;
        mem_reg_write <= ex_reg_write;
        mem_load <= ex_load;
        mem_store <= ex_store;
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
        $display("%.6f : [EX] ex_pc=%X, ex_npc=%X, A=%X, B=%X, ex_alu_op=%X(%s), Y=%X",
            $realtime, ex_pc, ex_npc,
            alu_A, alu_B, ex_alu_op, ex_alu_op_string, alu_Y);
    end
endmodule

