module WB(
    input  logic clk,
    input  logic rst_n,
    
    input  logic       wb_load_store,
    input  logic[31:0] wb_mem_rdata,
    input  logic[31:0] wb_alu_npc_out,
    input  logic[4:0]  wb_rd_idx,
    input  logic       wb_ebreak,
    
    output logic[31:0] wb_rd,

    input  logic       wb_trc_bubble,
    input  logic[31:0] wb_trc_pc,
    input  logic[31:0] wb_trc_instr
);
    always @(*) begin
        wb_rd = wb_load_store ? wb_mem_rdata : wb_alu_npc_out;
    end
    
    
    //
    // Tracing
    //
    always @(posedge(clk)) begin
        // EBREAK stops the simulation
        if (wb_ebreak) begin
            $display("********* EBREAK");
            $stop;
        end

        disassemble("WB", wb_trc_pc, wb_trc_instr, wb_trc_bubble);
        if (wb_rd_idx != 0) begin
            $display("[ WB]     x%0d <- %X", wb_rd_idx, wb_rd);
        end
    end
    
endmodule