module WB(
    input  logic clk,
    input  logic rst_n,

    input  logic       wb_ebreak,
    input  logic       wb_load,
    input  logic[1:0]  wb_addr,
    input  logic[2:0]  wb_size,
    input  logic[31:0] wb_mem_rdata,
    input  logic[31:0] wb_wdata,
    input  logic[4:0]  wb_rd_idx,
    
    output logic[31:0] wb_rd,

`ifdef TRACING
    input  logic       wb_trc_bubble,
    input  logic[31:0] wb_trc_pc,
    input  logic[31:0] wb_trc_instr
`endif
);
    always @(*) begin
        if (wb_load) begin
           // Process the loaded data: select bytes, zero or sign extend result
           casex ({wb_size,wb_addr})
           5'bx10xx: // lw
                wb_rd = wb_mem_rdata;
           5'b0010x: // lh, low half-word
                wb_rd = {{16{wb_mem_rdata[15]}},wb_mem_rdata[15:0]};
           5'b0011x: // lh, high half-word
                wb_rd = {{16{wb_mem_rdata[31]}},wb_mem_rdata[31:16]};
           5'b1010x: // lhu, low half-word
                wb_rd = {16'b0,wb_mem_rdata[15:0]};
           5'b1011x: // lhu, high half-word
                wb_rd = {16'b0,wb_mem_rdata[31:16]};
           5'b00000: // lb, byte 0
                wb_rd = {{24{wb_mem_rdata[7]}},wb_mem_rdata[7:0]};
           5'b00001: // lb, byte 1
                wb_rd = {{24{wb_mem_rdata[15]}},wb_mem_rdata[15:8]};
           5'b00010: // lb, byte 2
                wb_rd = {{24{wb_mem_rdata[23]}},wb_mem_rdata[23:16]};
           5'b00011: // lb, byte 3
                wb_rd = {{24{wb_mem_rdata[31]}},wb_mem_rdata[31:24]};
           5'b10000: // lbu, byte 0
                wb_rd = {24'b0,wb_mem_rdata[7:0]};
           5'b10001: // lbu, byte 1
                wb_rd = {24'b0,wb_mem_rdata[15:8]};
           5'b10010: // lbu, byte 2
                wb_rd = {24'b0,wb_mem_rdata[23:16]};
           5'b10011: // lbu, byte 3
                wb_rd = {24'b0,wb_mem_rdata[31:24]};
           endcase
        end else begin
            wb_rd = wb_wdata;
        end
    end
    
`ifdef TRACING
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
`endif

endmodule