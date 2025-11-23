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
    input logic[4:0]  mem_rd_idx,

    input logic       mem_instr_suppressed_tracing,
    
    // Data memory bus
    output logic[31:0] d_addr,
    output logic[31:0] d_wdata,
    input  logic[31:0] d_rdata,
    output logic       d_read,
    output logic       d_write,
    
    // Output to WB stage
    output logic       wb_load_store,
    output logic[31:0] wb_mem_rdata,
    output logic[31:0] wb_alu_npc_out,
    output logic[4:0]  wb_rd_idx,
    
    // Output to EX stage for hazard control
    output logic[31:0] mem_alu_npc_out,
    
    // Output to IF stage
    output logic[31:0] if_branch_target,
    output logic       if_take_branch
);
    
    always @(*) begin
        d_addr = mem_alu_out;
        d_read = mem_load;
        d_write = mem_store;
        
        mem_alu_npc_out = mem_jalx ? mem_npc : mem_alu_out;
        
        if_branch_target = mem_jalr ? mem_alu_out : mem_branch_target;
        if_take_branch = mem_jalx || (mem_bxx && mem_alu_out[0]);
    end
    
    always @(posedge(clk)) begin
        wb_load_store <= mem_load || mem_store;
        wb_mem_rdata <= d_rdata;
        wb_alu_npc_out <= mem_alu_npc_out;
        wb_rd_idx <= mem_rd_idx;
    end
    
    //
    // TRACING
    // 
    always @(posedge(clk)) begin
        $display("%.6f : [MEM] mem_npc=%X, mem_alu_npc_out:x%0d=%X",
            $realtime, mem_npc,
            mem_rd_idx, mem_alu_npc_out);
        if (mem_load) begin
            $display("    load %X -> %X", d_addr, d_rdata); 
        end
        if (mem_store) begin
            $display("    store %X -> %X", d_wdata, d_addr);             
        end
        $display("    if_take_branch=%d", if_take_branch);
        if (if_take_branch) begin
            $display("        if_branch_target=%X", if_branch_target);
        end
        if (mem_instr_suppressed_tracing) begin
            $display("        [MEM] <instr suppressed>");
        end
    end
endmodule