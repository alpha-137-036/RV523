
module CPU(
    input logic clk,
    input logic rst_n,
    
    // CODE interface
    output logic [31:0] c_addr,
    output logic        c_stb,
    input  logic        c_ack,
    input  logic [31:0] c_rdata,
    input  logic        c_stall,

    // DATA interface
    output logic [31:2] d_addr,
    output logic [31:0] d_wdata,
    input  logic [31:0] d_rdata,
    output logic        d_sel,
    output logic        d_write,
    output logic [3:0]  d_byte_sel
);

    logic [31:0] if_branch_target;
    logic if_take_branch;
    
    logic [31:0] id_pc, id_npc, id_instr;
    logic id_stall, id_bubble;
    
    logic [31:0] ex_imm, ex_rs1, ex_rs2, ex_pc, ex_npc, ex_trc_instr;
    logic [10:0] ex_alu_op;
    logic [4:0]  ex_rs1_idx, ex_rs2_idx, ex_rd_idx;
    logic [2:0]  ex_size;
    logic ex_alu_A_PC_sel, ex_alu_B_imm_sel, ex_load, ex_store, ex_jalr, ex_jalx, ex_bxx, ex_ebreak;
    logic ex_trc_bubble;
    
    logic [31:0] mem_addr, mem_wdata, mem_trc_pc, mem_trc_instr;
    logic [4:0]  mem_rd_idx;
    logic [2:0]  mem_size;
    logic mem_load, mem_store, mem_ebreak;
    logic mem_trc_bubble;

    logic [31:0] wb_wdata, wb_rd, wb_mem_rdata, wb_trc_pc, wb_trc_instr;
    logic [2:0]  wb_size;
    logic [4:0]  wb_rd_idx;
    logic [1:0]  wb_addr;
    logic wb_load, wb_ebreak, wb_trc_bubble;

`ifdef TRACING
    logic [31:0] trc_cycle_count, trc_instr_count;

    initial begin
        trc_cycle_count = 0;
        trc_instr_count = 0;
    end
`endif

    IF u_if(
        .clk(clk),
        .rst_n(rst_n),
        
        .c_addr(c_addr),
        .c_stb(c_stb),
        .c_ack(c_ack),
        .c_rdata(c_rdata),
        .c_stall(c_stall),

        .if_take_branch(if_take_branch),
        .if_branch_target(if_branch_target),
        .id_stall(id_stall),

        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr),
        .id_bubble(id_bubble)
    );
    ID u_id(
        .clk(clk),
        .rst_n(rst_n),
        
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr),
        .id_bubble(id_bubble),
        
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
        .ex_size(ex_size),
        .ex_jalr(ex_jalr),
        .ex_jalx(ex_jalx),
        .ex_bxx(ex_bxx),
        .ex_ebreak(ex_ebreak),

        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),
        
        .if_take_branch(if_take_branch),
        .id_stall(id_stall),

`ifdef TRACING
        .ex_trc_bubble(ex_trc_bubble),
        .ex_trc_instr(ex_trc_instr)
`endif
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
        .ex_size(ex_size),
        .ex_jalr(ex_jalr),
        .ex_jalx(ex_jalx),
        .ex_bxx(ex_bxx),
        .ex_ebreak(ex_ebreak),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_load(mem_load),
        .mem_store(mem_store),
        .mem_size(mem_size),
        .mem_ebreak(mem_ebreak),
        .mem_rd_idx(mem_rd_idx),
        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),
        .if_take_branch(if_take_branch),
        .if_branch_target(if_branch_target),

`ifdef TRACING
        .ex_trc_bubble(ex_trc_bubble),
        .ex_trc_instr(ex_trc_instr),
        .mem_trc_bubble(mem_trc_bubble),
        .mem_trc_pc(mem_trc_pc),
        .mem_trc_instr(mem_trc_instr)
`endif
    );

    MEM u_mem(
        .clk(clk),
        .rst_n(rst_n),

        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_load(mem_load),
        .mem_store(mem_store),
        .mem_size(mem_size),
        .mem_ebreak(mem_ebreak),
        .mem_rd_idx(mem_rd_idx),

        .wb_load(wb_load),
        .wb_size(wb_size),
        .wb_addr(wb_addr),
        .wb_ebreak(wb_ebreak),
        .wb_mem_rdata(wb_mem_rdata),
        .wb_wdata(wb_wdata),
        .wb_rd_idx(wb_rd_idx),

        .d_addr(d_addr),
        .d_sel(d_sel),
        .d_write(d_write),
        .d_byte_sel(d_byte_sel),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata),

`ifdef TRACING
        .mem_trc_bubble(mem_trc_bubble),
        .mem_trc_pc(mem_trc_pc),
        .mem_trc_instr(mem_trc_instr),
        .wb_trc_bubble(wb_trc_bubble),
        .wb_trc_pc(wb_trc_pc),
        .wb_trc_instr(wb_trc_instr)
`endif
    );

    WB u_wb(
        .clk(clk),
        .rst_n(rst_n),
        
        .wb_ebreak(wb_ebreak),
        .wb_load(wb_load),
        .wb_addr(wb_addr),
        .wb_size(wb_size),
        .wb_mem_rdata(wb_mem_rdata),
        .wb_wdata(wb_wdata),
        .wb_rd_idx(wb_rd_idx),
        .wb_rd(wb_rd),

`ifdef TRACING
        .wb_trc_pc(wb_trc_pc),
        .wb_trc_instr(wb_trc_instr),
        .wb_trc_bubble(wb_trc_bubble)
`endif
    );


`ifdef TRACING
    always @(posedge(clk)) begin
        trc_cycle_count++;
        if (rst_n && !wb_trc_bubble) begin
            trc_instr_count++;
        end
        $strobe("------- %.6f: cycle %0d, instr %0d", $realtime, trc_cycle_count, trc_instr_count);
    end
`endif
endmodule
