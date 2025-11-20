//
// CPU execution stage
//
module select3(
    input logic[2:0] sel,
    input logic[31:0] in0,
    input logic[31:0] in1,
    input logic[31:0] in2,
    output logic[31:0] out
);
    always_comb begin
        case (sel)
            3'b001: out = in0; 
            3'b010: out = in1;
            3'b100: out = in2;
            default: out = 'X;
        endcase
    end
endmodule

module EX_Select(
    // Inputs from ID stage
    input logic[31:0] rs1,
    input logic[31:0] rs2,
    input logic[31:0] imm,
    input logic[`PCWIDTH-1:2] pc,
    input logic[`PCWIDTH-1:2] next_pc,
    
    // Inputs from MEM stage
    input logic[31:0] mem_fwd,
    
    // Inputs from the WB stage
    input logic[31:0] wb_fwd,
    
    // Inputs from the control/hazard units
    input logic [2:0] rs1_fwd_sel,
    input logic [2:0] rs2_fwd_sel,
    
    input logic alu_A_rs1,
    input logic alu_B_rs2,
    
    // Outputs to ALU    
    output logic[31:0] alu_A,
    output logic[31:0] alu_B,
    
    // Output to MEM stage 
    output logic[31:0] wdata,
);
    logic[31:0] rs1_fwd;
    logic[31:0] rs2_fwd;
    logic[31:0] alu_A;
    
    // Select rs1 from ID stage or forwarded from MEM or WB stage
    select3 u_sel_rs1(
        .sel(rs1_fwd_sel),
        .in0(rs1),
        .in1(mem_fwd),
        .in2(wd_fwd),
        .out(rs1_fwd));
        
    assign wdata = rs1_fwd;
  
    // Select ALU A argument from either RS1 or PC
    assign alu_A = alu_A_rs1 ? rs1_fwd : {{(32-`PCWIDTH){1'b0}}, pc, 2'b00};
       
    // Select RS2 from ID stage or forwarded from MEM or WB stage
    select3 u_sel_rs2(
        .sel(rs2_fwd_sel),
        .in0(rs2),
        .in1(mem_fwd),
        .in2(wd_fwd),
        .out(rs2_fwd));
       
    // Select ALU B argument from either RS2 or IMM
    assign alu_B = alu_B_rs2 ? rs2_fwd : imm;
               
endmodule

module BranchAdder(
    input logic[`PCWIDTH-1:2] A,
    input logic[`PCWIDTH-1:2] B,
    output logic[`PCWIDTH-1:2] Y
);
    assign Y = A + B;
endmodule

module EX(
    // Inputs from ID stage
    input logic[31:0] rs1,
    input logic[31:0] rs2,
    input logic[31:0] imm,
    input logic[`PCWIDTH-1:2] pc,
    input logic[`PCWIDTH-1:2] next_pc,
    
    // Inputs from MEM stage
    input logic[31:0] mem_fwd,
    
    // Inputs from the WB stage
    input logic[31:0] wb_fwd,
    
    // Inputs from the control/hazard units
    input logic [2:0] rs1_fwd_sel,
    input logic [2:0] rs2_fwd_sel,
    
    input logic alu_A_rs1,
    input logic alu_B_rs2,
    
    input logic [11:0] alu_ctrl,
    
    // Output to MEM stage 
    output logic[31:0] alu_Y,
    output logic[31:0] wdata,
    output logic[31:0] branch_target
);
    logic[31:0] alu_A;
    logic[31:0] alu_B;
    
    EX_Select u_select(
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm),
        .pc(pc),
        .mem_fwd(mem_fwd),
        .wb_fwd(wb_fwd),
        .rs1_fwd_sel(rs1_fwd_sel),
        .rs2_fwd_sel(rs2_fwd_sel),
        .alu_A_rs1(alu_A_rs1),
        .alu_B_rs2(alu_B_rs2),
        .alu_A(alu_A),
        .alu_B(alu_B),
        .wdata(wdata));
        
    ALU u_alu(
        .ctrl(alu_ctrl),
        .A(alu_A),
        .B(alu_B),
        .Y(alu_Y));
        
    BranchAdder u_branch(
        .A(pc),
        .B(imm),
        .Y(branch_target));
endmodule