module WB(
    input logic clk,
    input logic rst_n,
    
    input logic       wb_load_store,
    input logic[31:0] wb_mem_rdata,
    input logic[31:0] wb_alu_npc_out,
    input logic[4:0]  wb_rd_idx,
    input logic       wb_bubble_tracing,
    
    output logic[31:0] wb_rd    
);
    always @(*) begin
        wb_rd = wb_load_store ? wb_mem_rdata : wb_alu_npc_out;
    end
    
    
    //
    // Tracing
    //
    always @(posedge(clk)) begin
        $display("%.6f : [WB] x%0d <- %X", $realtime, wb_rd_idx, wb_rd);
        if (wb_bubble_tracing) begin
            $display("    [WB] <bubble>");
        end
    end
    
endmodule