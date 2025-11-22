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
    input logic[4:0]  mem_rd_idx,
    
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
    output logic[31:0] mem_alu_npc_out
);

    always @(*) begin
        d_addr = mem_alu_out;
        d_read = mem_load;
        d_write = mem_store;
        
        mem_alu_npc_out = mem_alu_out; // TODO: mux with npc
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
    end
endmodule