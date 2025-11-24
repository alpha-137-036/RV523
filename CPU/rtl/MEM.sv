module MEM(
    input logic clk,
    input logic rst_n,
    
    // Inputs from EX stage
    input logic[31:0] mem_alu_out,
    input logic[31:0] mem_wdata,
    input logic[31:0] mem_branch_target,
    input logic[31:0] mem_npc,
    input logic       mem_load,
    input logic       mem_store,
    input logic       mem_jalr,
    input logic       mem_jalx,
    input logic       mem_bxx,
    input logic       mem_ebreak,
    input logic[4:0]  mem_rd_idx,
    
    // Data memory bus
    output logic[31:0] d_addr,
    output logic[31:0] d_wdata,
    input  logic[31:0] d_rdata,
    output logic       d_read,
    output logic       d_write,
    
    // Output to WB stage
    output logic       wb_load_store,
    output logic       wb_ebreak,
    output logic[31:0] wb_mem_rdata,
    output logic[31:0] wb_alu_npc_out,
    output logic[4:0]  wb_rd_idx,
    
    // Output to EX stage for hazard control
    output logic[31:0] mem_alu_npc_out,
    
    // Output to IF stage
    output logic[31:0] if_branch_target,
    output logic       if_take_branch,

    input  logic       mem_trc_bubble,
    input  logic[31:0] mem_trc_pc,
    input  logic[31:0] mem_trc_instr,
    output logic       wb_trc_bubble,
    output logic[31:0] wb_trc_pc,
    output logic[31:0] wb_trc_instr
);
    
    always @(*) begin
        d_addr = mem_alu_out;
        d_read = mem_load;
        d_write = mem_store;
        
        d_wdata = mem_wdata;
        
        mem_alu_npc_out = mem_jalx ? mem_npc : mem_alu_out;
        
        if_branch_target = mem_jalr ? mem_alu_out : mem_branch_target;
        if_take_branch = mem_jalx || (mem_bxx && mem_alu_out[0]);
    end
    
    always @(posedge(clk)) begin
        wb_load_store <= mem_load || mem_store;
        wb_ebreak <= mem_ebreak;
        wb_mem_rdata <= d_rdata;
        wb_alu_npc_out <= mem_alu_npc_out;
        wb_rd_idx <= mem_rd_idx;
        wb_trc_bubble <= mem_trc_bubble;
        wb_trc_pc <= mem_trc_pc;
        wb_trc_instr <= mem_trc_instr;
    end
    
    //
    // TRACING
    // 
    always @(posedge(clk)) begin
        disassemble("MEM", mem_trc_pc, mem_trc_instr, mem_trc_bubble);
        if (mem_load) begin
            $display("[MEM] load %X -> %X", d_addr, d_rdata); 
        end
        if (mem_store) begin
            $display("[MEM] store %X -> %X", d_wdata, d_addr);             
        end
        if (if_take_branch) begin
            $display("[MEM] branch to %X", if_branch_target);
        end
    end
endmodule