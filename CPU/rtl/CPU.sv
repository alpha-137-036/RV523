
module CPU(
    input logic clk,
    input logic rst_n,
    
    // ROM interface
    output logic [31:0] c_addr,
    input  logic [31:0] c_rdata
);
    logic [31:0] id_pc, id_npc, id_instr, ex_imm, ex_rs1, ex_rs2, ex_pc, ex_npc;
    logic [11:0] ex_alu_op;
    logic ex_alu_A_PC_sel, ex_alu_B_imm_sel;

    IF u_if(
        .clk(clk),
        .rst_n(rst_n),
        
        .c_addr(c_addr),
        .c_rdata(c_rdata),
        .branch(1'b0),
        
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr)
    );
    ID u_id(
        .clk(clk),
        .rst_n(rst_n),
        
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr),
        
        .id_write(1'b0),
        .ex_imm(ex_imm),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_pc(ex_pc),
        .ex_npc(ex_npc),
        .ex_alu_op(ex_alu_op),
        .ex_alu_A_PC_sel(ex_alu_A_PC_sel),
        .ex_alu_B_imm_sel(ex_alu_B_imm_sel)
    );
    
    EX u_ex(
        .clk(clk),
        .rst_n(rst_n),
        .ex_alu_A_PC_sel(ex_alu_A_PC_sel),
        .ex_alu_B_imm_sel(ex_alu_B_imm_sel),
        .ex_alu_op(ex_alu_op),
        .ex_imm(ex_imm),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_pc(ex_pc),
        .ex_npc(ex_npc),
        .ex_rs1_fwd_sel(2'b00),
        .ex_rs2_fwd_sel(2'b00)
    );

endmodule
