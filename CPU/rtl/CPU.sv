
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

    logic [31:0] if_branch_target;
    logic if_take_branch;
    
    logic [31:0] id_pc, id_npc, id_instr;
    logic id_bubble_tracing;
    
    logic [31:0] ex_imm, ex_rs1, ex_rs2, ex_pc, ex_npc;
    logic [11:0] ex_alu_op;
    logic [4:0]  ex_rs1_idx, ex_rs2_idx, ex_rd_idx;
    logic ex_alu_A_PC_sel, ex_alu_B_imm_sel, ex_load, ex_store, ex_jalr, ex_jalx, ex_bxx;
    logic ex_bubble_tracing;
    
    logic [31:0] mem_alu_out, mem_alu_npc_out, mem_wdata, mem_branch_target, mem_npc;
    logic [4:0]  mem_rd_idx;
    logic mem_load, mem_store, mem_jalr, mem_jalx, mem_bxx;
    logic mem_bubble_tracing;

    logic [31:0] wb_alu_npc_out, wb_rd, wb_mem_rdata;
    logic [4:0]  wb_rd_idx;
    logic wb_load_store, wb_bubble_tracing;

    IF u_if(
        .clk(clk),
        .rst_n(rst_n),
        
        .c_addr(c_addr),
        .c_rdata(c_rdata),
        .if_take_branch(if_take_branch),
        .if_branch_target(if_branch_target),
        
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr),
        .id_bubble_tracing(id_bubble_tracing)
    );
    ID u_id(
        .clk(clk),
        .rst_n(rst_n),
        
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr),
        .id_bubble_tracing(id_bubble_tracing),
        
        .ex_imm(ex_imm),
        .ex_rs1(ex_rs1),
        .ex_rs1_idx(ex_rs1_idx),
        .ex_rs2(ex_rs2),
        .ex_rs2_idx(ex_rs2_idx),
        .ex_rd_idx(ex_rd_idx),
        .ex_pc(ex_pc),
        .ex_npc(ex_npc),
        .ex_alu_op(ex_alu_op),
        .ex_alu_A_PC_sel(ex_alu_A_PC_sel),
        .ex_alu_B_imm_sel(ex_alu_B_imm_sel),
        .ex_load(ex_load),
        .ex_store(ex_store),
        .ex_jalr(ex_jalr),
        .ex_jalx(ex_jalx),
        .ex_bxx(ex_bxx),
        .ex_bubble_tracing(ex_bubble_tracing),

        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),
        
        .if_take_branch(if_take_branch)
    );
    
    EX u_ex(
        .clk(clk),
        .rst_n(rst_n),
        .ex_alu_A_PC_sel(ex_alu_A_PC_sel),
        .ex_alu_B_imm_sel(ex_alu_B_imm_sel),
        .ex_alu_op(ex_alu_op),
        .ex_imm(ex_imm),
        .ex_rs1(ex_rs1),
        .ex_rs1_idx(ex_rs1_idx),
        .ex_rs2(ex_rs2),
        .ex_rs2_idx(ex_rs2_idx),
        .ex_rd_idx(ex_rd_idx),
        .ex_pc(ex_pc),
        .ex_npc(ex_npc),
        .ex_load(ex_load),
        .ex_store(ex_store),
        .ex_jalr(ex_jalr),
        .ex_jalx(ex_jalx),
        .ex_bxx(ex_bxx),
        .ex_bubble_tracing(ex_bubble_tracing),
        .mem_alu_out(mem_alu_out),
        .mem_wdata(mem_wdata),
        .mem_branch_target(mem_branch_target),
        .mem_npc(mem_npc),
        .mem_load(mem_load),
        .mem_store(mem_store),
        .mem_jalr(mem_jalr),
        .mem_jalx(mem_jalx),
        .mem_bxx(mem_bxx),
        .mem_rd_idx(mem_rd_idx),
        .mem_alu_npc_out(mem_alu_npc_out),
        .mem_bubble_tracing(mem_bubble_tracing),
        .if_take_branch(if_take_branch),
        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd)
    );

    MEM u_mem(
        .clk(clk),
        .rst_n(rst_n),

        .mem_alu_out(mem_alu_out),
        .mem_wdata(mem_wdata),
        .mem_branch_target(mem_branch_target),
        .mem_npc(mem_npc),
        .mem_load(mem_load),
        .mem_store(mem_store),
        .mem_jalr(mem_jalr),
        .mem_jalx(mem_jalx),
        .mem_bxx(mem_bxx),
        .mem_rd_idx(mem_rd_idx),
        .mem_alu_npc_out(mem_alu_npc_out),
        .mem_bubble_tracing(mem_bubble_tracing),

        .wb_load_store(wb_load_store),
        .wb_mem_rdata(wb_mem_rdata),
        .wb_alu_npc_out(wb_alu_npc_out),
        .wb_rd_idx(wb_rd_idx),
        .wb_bubble_tracing(wb_bubble_tracing),

        .if_take_branch(if_take_branch),
        .if_branch_target(if_branch_target)
    );

    WB u_wb(
        .clk(clk),
        .rst_n(rst_n),
        
        .wb_load_store(wb_load_store),
        .wb_mem_rdata(wb_mem_rdata),
        .wb_alu_npc_out(wb_alu_npc_out),
        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),
        .wb_bubble_tracing(wb_bubble_tracing)
    );


    always @(posedge(clk)) begin
        $strobe("-------");
    end

endmodule
