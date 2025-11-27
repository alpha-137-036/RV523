module WB(
    input  logic clk,
    input  logic rst_n,
    
    input  logic       wb_load,
    input  logic       wb_ebreak,
    input  logic[2:0]  wb_size,
    input  logic[31:0] wb_mem_rdata,
    input  logic[31:0] wb_alu_npc_out,
    input  logic[4:0]  wb_rd_idx,
    
    output logic[31:0] wb_rd,

    input  logic       wb_trc_bubble,
    input  logic[31:0] wb_trc_pc,
    input  logic[31:0] wb_trc_instr
);
    always @(*) begin
        if (wb_load) begin
           // Process the loaded data: zero or sign extend
           case (wb_size)
           3'b000: // lb
                wb_rd = {{24{wb_mem_rdata[7]}},wb_mem_rdata[7:0]};
           3'b100: // lbu
                wb_rd = {24'b0,wb_mem_rdata[7:0]};
           3'b001: // lh
                wb_rd = {{16{wb_mem_rdata[15]}},wb_mem_rdata[15:0]};
           3'b101: // lhu
                wb_rd = {16'b0,wb_mem_rdata[15:0]};
           3'bx00: // lw
                wb_rd = wb_mem_rdata;
           endcase
        end else begin
            wb_rd = wb_alu_npc_out;
        end
    end
    
    
    //
    // Tracing
    //
    always @(posedge(clk)) begin
        disassemble("WB", wb_trc_pc, wb_trc_instr, wb_trc_bubble);
        if (wb_rd_idx != 0) begin
            $display("[ WB]     x%0d <- %X", wb_rd_idx, wb_rd);
        end
        // EBREAK stops the simulation
        if (wb_ebreak) begin
            $display("********* EBREAK");
            $stop;
        end
    end
    
endmodule