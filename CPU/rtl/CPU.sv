
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

    logic [31:0] if_branch_target, if_trc_instr;
    logic if_take_branch;
    
    logic [31:0] id_pc, id_npc, id_instr;
    logic id_trc_bubble;
    
    logic [31:0] ex_imm, ex_rs1, ex_rs2, ex_pc, ex_npc, ex_trc_instr;
    logic [10:0] ex_alu_op;
    logic [4:0]  ex_rs1_idx, ex_rs2_idx, ex_rd_idx;
    logic ex_alu_A_PC_sel, ex_alu_B_imm_sel, ex_load, ex_store, ex_jalr, ex_jalx, ex_bxx, ex_ebreak;
    logic ex_trc_bubble;
    
    logic [31:0] mem_alu_out, mem_alu_npc_out, mem_wdata, mem_branch_target, mem_npc, mem_trc_pc, mem_trc_instr;
    logic [4:0]  mem_rd_idx;
    logic mem_load, mem_store, mem_jalr, mem_jalx, mem_bxx, mem_ebreak;
    logic mem_trc_bubble;

    logic [31:0] wb_alu_npc_out, wb_rd, wb_mem_rdata, wb_trc_pc, wb_trc_instr;
    logic [4:0]  wb_rd_idx;
    logic wb_load_store, wb_ebreak, wb_trc_bubble;

    IF u_if(
        .clk(clk),
        .rst_n(rst_n),
        
        .c_addr(c_addr),
        .c_rdata(c_rdata),
        .if_take_branch(if_take_branch),
        .if_branch_target(if_branch_target),
        .id_stall(id_stall),

        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr),
        
        .if_trc_instr(if_trc_instr),
        .id_trc_bubble(id_trc_bubble)
    );
    ID u_id(
        .clk(clk),
        .rst_n(rst_n),
        
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr),
        
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
        .ex_ebreak(ex_break),

        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),
        
        .if_take_branch(if_take_branch),
        .id_stall(id_stall),

        .id_trc_bubble(id_trc_bubble),
        .ex_trc_bubble(ex_trc_bubble),
        .ex_trc_instr(ex_trc_instr)
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
        .ex_ebreak(ex_break),
        .mem_alu_out(mem_alu_out),
        .mem_wdata(mem_wdata),
        .mem_branch_target(mem_branch_target),
        .mem_npc(mem_npc),
        .mem_load(mem_load),
        .mem_store(mem_store),
        .mem_jalr(mem_jalr),
        .mem_jalx(mem_jalx),
        .mem_bxx(mem_bxx),
        .mem_ebreak(mem_ebreak),
        .mem_rd_idx(mem_rd_idx),
        .mem_alu_npc_out(mem_alu_npc_out),
        .if_take_branch(if_take_branch),
        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),

        .ex_trc_bubble(ex_trc_bubble),
        .ex_trc_instr(ex_trc_instr),
        .mem_trc_bubble(mem_trc_bubble),
        .mem_trc_pc(mem_trc_pc),
        .mem_trc_instr(mem_trc_instr)
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
        .mem_ebreak(mem_ebreak),
        .mem_rd_idx(mem_rd_idx),
        .mem_alu_npc_out(mem_alu_npc_out),

        .wb_load_store(wb_load_store),
        .wb_ebreak(wb_ebreak),
        .wb_mem_rdata(wb_mem_rdata),
        .wb_alu_npc_out(wb_alu_npc_out),
        .wb_rd_idx(wb_rd_idx),

        .if_take_branch(if_take_branch),
        .if_branch_target(if_branch_target),

        .d_addr(d_addr),
        .d_read(d_read),
        .d_write(d_write),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata),

        .mem_trc_bubble(mem_trc_bubble),
        .mem_trc_pc(mem_trc_pc),
        .mem_trc_instr(mem_trc_instr),
        .wb_trc_bubble(wb_trc_bubble),
        .wb_trc_pc(wb_trc_pc),
        .wb_trc_instr(wb_trc_instr)
    );

    WB u_wb(
        .clk(clk),
        .rst_n(rst_n),
        
        .wb_load_store(wb_load_store),
        .wb_ebreak(wb_ebreak),
        .wb_mem_rdata(wb_mem_rdata),
        .wb_alu_npc_out(wb_alu_npc_out),
        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),
        
        .wb_trc_pc(wb_trc_pc),
        .wb_trc_instr(wb_trc_instr),
        .wb_trc_bubble(wb_trc_bubble)
    );


    always @(posedge(clk)) begin
        $strobe("------- %.6f", $realtime);
    end

endmodule
