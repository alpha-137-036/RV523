
module CPU(
    input logic clk,
    input logic rst_n,
    
    // CODE interface
    output logic [31:0] c_addr,
    input  logic [31:0] c_rdata,

    // DATA interface
    output logic [31:0] d_addr,
    output logic [31:0] d_wdata,
    input  logic [31:0] d_rdata,
    output logic        d_read,
    output logic        d_write
);
    logic [31:0] id_pc, id_npc, id_instr;
    logic [31:0] ex_imm, ex_rs1, ex_rs2, ex_pc, ex_npc;
    logic [11:0] ex_alu_op;
    logic ex_alu_A_PC_sel, ex_alu_B_imm_sel, ex_reg_write, ex_load, ex_store;
    logic [31:0] mem_alu_out, mem_wdata, mem_branch_target, mem_npc;
    logic mem_reg_write, mem_load, mem_store;

    logic [31:0] wb_reg_wdata;
    logic wb_reg_write;

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
        .ex_alu_B_imm_sel(ex_alu_B_imm_sel),
        .ex_reg_write(ex_reg_write),
        .ex_load(ex_load),
        .ex_store(ex_store)
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
        .ex_rs2_fwd_sel(2'b00),
        .ex_reg_write(ex_reg_write),
        .ex_load(ex_load),
        .ex_store(ex_store),
        .mem_alu_out(mem_alu_out),
        .mem_wdata(mem_wdata),
        .mem_branch_target(mem_branch_target),
        .mem_npc(mem_npc),
        .mem_reg_write(mem_reg_write),
        .mem_load(mem_load),
        .mem_store(mem_store)
    );

    MEM u_mem(
        .clk(clk),
        .rst_n(rst_n),

        .mem_alu_out(mem_alu_out),
        .mem_wdata(mem_wdata),
        .mem_branch_target(mem_branch_target),
        .mem_npc(mem_npc),
        .mem_reg_write(mem_reg_write),
        .mem_load(mem_load),
        .mem_store(mem_store),

        .wb_reg_wdata(wb_reg_wdata),
        .wb_reg_write(wb_reg_write)
    );

    WB u_wb(
        .clk(clk),
        .rst_n(rst_n)
    );


    always @(posedge(clk)) begin
        $strobe("-------");
    end

endmodule
