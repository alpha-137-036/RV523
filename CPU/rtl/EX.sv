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
    input logic[31:0] ex_rs1,
    input logic[31:0] ex_rs2,
    input logic[31:0] ex_imm,
    input logic[31:0] ex_pc,
    input logic[31:0] ex_npc,
    input logic ex_alu_A_PC_sel,
    input logic ex_alu_B_imm_sel,
    input logic[11:0] ex_alu_ctrl,
    
    // Inputs from MEM stage
    input logic[31:0] mem_fwd,
    
    // Inputs from the WB stage
    input logic[31:0] wb_fwd,
    
    // Inputs from the control/hazard units
    input logic [1:0] ex_rs1_fwd_sel,
    input logic [1:0] ex_rs2_fwd_sel,
    
    // Output to MEM stage 
    output logic [31:0] mem_alu_out,
    output logic[31:0] mem_wdata
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
        .ctrl(ex_alu_ctrl),
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
    end
    
    
    //
    //
    // TRACING
    //
    //
    always @(posedge clk) begin
        $display("%.6f : [EX] ex_pc=%X, ex_npc=%X, A=%X, B=%X, Y=%X",
            $realtime, ex_pc, ex_npc,
            alu_A, alu_B, alu_Y);
    end
endmodule

